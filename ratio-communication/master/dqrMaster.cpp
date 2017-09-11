#include "dqrMaster.h"


/**************************************** GLOBAL VARIABLES ****************************************/

/*** Mesh RF24 Network ***/
RF24 radio(RPI_V2_GPIO_P1_15, BCM2835_SPI_CS0, BCM2835_SPI_SPEED_8MHZ);  
RF24Network network(radio);
RF24Mesh mesh(radio,network);

/*** Mysql Database variables ***/
string db_url = std::string("tcp://") + DB_HOST + ":3306";
sql::mysql::MySQL_Driver *driver;
sql::Connection *con;
sql::Statement *stmt;
sql::ResultSet  *res;

using namespace std;

/**************************************** MAIN ****************************************/
int main(int argc, char** argv) {
	
	/*** Fork Ratio Listener ***/
	int chi2par[2], par2chi[2];
	pid_t   listenerPid;
	operation_t operation;
	
	// Parent - Child IPC
	pipe(chi2par);
	pipe(par2chi);
	
	if ( (listenerPid = fork()) == -1 ) {
		perror("[Master Server] Error forking listener...");
		exit(1);
	}
	
	/*** Listener Operation - Child Process ***/
	if (listenerPid == 0) {
		// Closing Pipes Ends
		close(chi2par[0]);
		close(par2chi[1]);
		
		Listener listener = Listener();
		listener.setPipes(chi2par,par2chi);
		listener.run();
		
		exit(0);
	} else {
	/*** Master Server Operation - Parent Process ***/
		// Closing Pipes Ends
		close(chi2par[1]);
		close(par2chi[0]);
		
		// Setting pipe with listener in non-blocking mode
		fcntl( chi2par[0], F_SETFL, fcntl(chi2par[0], F_GETFL) | O_NONBLOCK);
		
		// Master Node => NodeID = 0
		mesh.setNodeID(0);
		// Mesh Connection
		printf("[Master Server] Initializing Mesh Network...\n");
		mesh.begin();
		radio.printDetails();

		/*** Mesh Update and Message Listening ***/
		while(1) {
		  
			// Network Update - Running...
			mesh.update();

			// Mesh DHCP Service for dynamic node addressing
			mesh.DHCP();

			// Check for incoming data from the sensors
			while(network.available()) {
				// Header peek to decide which payload structure is sent
				RF24NetworkHeader header;
				network.peek(header);
				
				try {
					// Mysql DB Connection
					driver = sql::mysql::get_mysql_driver_instance();
					con = driver->connect(db_url, DB_USER, DB_PASS);
					con->setSchema(DB_SCHEMA);
					stmt = con->createStatement();
				
					switch(header.type) {
						case INFORM_MESSAGE: {
							// Received Information Type Message
							payload_I dat;
							network.read(header,&dat,sizeof(dat)); 
							printf("[Master Server] Rcv data from 0%o\n",header.from_node);
							printf(" - Device Id: %d\n",dat.deviceId);
													
							stmt->execute("START TRANSACTION");
							
							int i = 0;
							while (i < MAX_MODULES_X_DEVICE && dat.modules[i].moduleId != 0) {
								printf("   . Module Id: %d\n",dat.modules[i].moduleId);
								printf("   . Module State: %d\n",dat.modules[i].state);
								
								//qry = std::string("INSERT INTO events (module_id, state, ts) VALUES (") + std::to_string(dat.modules[i].moduleId) + "," + std::to_string(dat.modules[i].state) + ",NOW() )";
								string qry = string("select generate_event(") + std::to_string(dat.modules[i].moduleId) + "," + std::to_string(dat.modules[i].state) + ")";
								res = stmt->executeQuery(qry);
								//res = stmt->executeQuery("SELECT LAST_INSERT_ID()");
								res->next();
								int event_id = res->getInt(1);
								
								int j = 0;
								while (j < MAX_SENSORS_X_MODULE && dat.modules[i].sensors[j].sensorType != 0) {
									printf("     . Sensor Type: %d\n",dat.modules[i].sensors[j].sensorType);
									printf("     . Sensor Value: %f\n",dat.modules[i].sensors[j].value);
									
									//qry = std::string("INSERT INTO event_sensors (event_id, sensor_type_id, value) VALUES (") + std::to_string(event_id) + "," + std::to_string(dat.modules[i].sensors[j].sensorType) + "," + std::to_string(dat.modules[i].sensors[j].value) + ")";
									qry = string("call generate_event_data(") + std::to_string(event_id) + "," + std::to_string(dat.modules[i].sensors[j].sensorType) + "," + std::to_string(dat.modules[i].sensors[j].value) + ")";
									stmt->execute(qry);

									j++;
								}
								i++;
							}
							
							con->commit();
							
							 break;
						}
						default:  network.read(header,0,0); 
							printf("[Master Server] Rcv bad type %d from 0%o\n",header.type,header.from_node); 
							break;
					}
					
					delete stmt;
					delete con;
				} catch (sql::SQLException &e) {
					cout << "[Master Server] # ERR: SQLException in " << __FILE__;
					cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << endl;
					cout << "# ERR: " << e.what();
					cout << " (MySQL error code: " << e.getErrorCode();
					cout << ", SQLState: " << e.getSQLState() << " )" << endl;
				}
			}
			
			// Listener requests received?
			int readsize = read(chi2par[0], &operation, sizeof(operation_t));
			
			if ( readsize > 0 ) {
				// Received message from Listener
				int response = -1;
				int count = 0;
				
				printf("[Master Server] Rcv request (type: %c) from listener\n",operation.type);
				printf("[Master Server] ........ Device Id: %d\n",operation.deviceId);
				
				switch(operation.type) {
					case REQUEST_MESSAGE:
						payload_S req_s;
						req_s.subtype = all;
						
						while ( count < MAX_MESH_WRITE_RETRIES && response != 0 ) {
							if ( mesh.write(&req_s,REQUEST_MESSAGE,sizeof(req_s),operation.deviceId) ) {
								response = 0;
							}
							count++;
						}
						break;
					case ACTION_MESSAGE:
						printf("[Master Server] ........ Module Id: %d\n",operation.moduleId);
						printf("[Master Server] ........ Desired State: %d\n",operation.desiredState);
						payload_A req_a;
						req_a.moduleId = operation.moduleId;
						req_a.desiredState = operation.desiredState;
						
						while ( count < MAX_MESH_WRITE_RETRIES && response != 0 ) {
							if ( mesh.write(&req_a,ACTION_MESSAGE,sizeof(req_a),operation.deviceId) ) {
								response = 0;
							}
							count++;
						}
						break;
					default:
						printf("[Master Server] Rcv bad type (%c) from listener\n",operation.type);
						break;
				}
				
				// Response for current request
				write(par2chi[1], &response, sizeof(response));
            } else {
				// No requests received - continue...
                //printf("Nothing read\n");
                //perror("Error: ");
            }
		
			delay(1);
		}
	}
	return 0;
}