#include <stdlib.h>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>

/*** Includes RF24 ***/
#include "RF24Mesh/RF24Mesh.h"  
#include <RF24/RF24.h>
#include <RF24Network/RF24Network.h>

/*** Includes MySQL ***/
#include "mysql_connection.h"
#include <mysql_driver.h>
#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <cppconn/prepared_statement.h>

/**************************************** STATIC CONFIGURATION ****************************************/
/*** Configuration Constants ***/
#define MAX_SENSORS_X_MODULE 5
#define MAX_MODULES_X_DEVICE  3

/*** Communication Protocol ***/
#define byte uint8_t
#define REQUEST_MESSAGE 'S'
#define INFORM_MESSAGE 'I'
#define ACTION_MESSAGE 'A'
#define S_SUBTYPE_ALL 0
#define S_SUBTYPE_STATE 1
#define S_SUBTYPE_SENSOR 2
enum S_subtype { all = S_SUBTYPE_ALL, state = S_SUBTYPE_STATE, sensor = S_SUBTYPE_SENSOR };
struct __attribute__ ((__packed__)) payload_S {
  S_subtype subtype;
  byte modules[MAX_MODULES_X_DEVICE];
  byte sensors[MAX_SENSORS_X_MODULE];
};
struct __attribute__ ((__packed__)) payload_sensor {
  byte sensorType = 0;
  float value;
};
struct __attribute__ ((__packed__)) payload_module {
  byte moduleId = 0;
  byte state = 0;
  payload_sensor sensors[MAX_SENSORS_X_MODULE];
};
struct __attribute__ ((__packed__)) payload_I {
  byte deviceId = 0;
  payload_module modules[MAX_MODULES_X_DEVICE];
};
struct __attribute__ ((__packed__)) payload_A {
  byte desiredState;
  byte moduleId;
};


/*** Mysql DB Config ***/
#define DB_HOST "localhost"
#define DB_USER "root"
#define DB_PASS "root"
#define DB_SCHEMA "ratio_dev"


/**************************************** GLOBAL VARIABLES ****************************************/
RF24 radio(RPI_V2_GPIO_P1_15, BCM2835_SPI_CS0, BCM2835_SPI_SPEED_8MHZ);  
RF24Network network(radio);
RF24Mesh mesh(radio,network);


using namespace std;

/**************************************** MAIN ****************************************/
int main(int argc, char** argv) {
  
	// Mysql DB Vars
	string db_url = std::string("tcp://") + DB_HOST + ":3306";
	string qry;
	int last_inserted;
	sql::mysql::MySQL_Driver *driver;
	sql::Connection *con;
	sql::Statement *stmt;
	sql::ResultSet  *res;
	
	// Master Node => NodeID = 0
	mesh.setNodeID(0);
	// Mesh Connection
	printf("Initializing Mesh Network...\n");
	mesh.begin();
	//radio.printDetails();

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
				driver = sql::mysql::get_mysql_driver_instance();
				con = driver->connect(db_url, DB_USER, DB_PASS);
				con->setSchema(DB_SCHEMA);
				stmt = con->createStatement();
			
				switch(header.type) {
					case 'I': {
						payload_I dat;
						network.read(header,&dat,sizeof(dat)); 
						printf("Rcv data from 0%o\n",header.from_node);
						printf(" - Device Id: %d\n",dat.deviceId);
												
						stmt->execute("START TRANSACTION");
						
						int i = 0;
						while (i < MAX_MODULES_X_DEVICE && dat.modules[i].moduleId != 0) {
							printf("   . Module Id: %d\n",dat.modules[i].moduleId);
							printf("   . Module State: %d\n",dat.modules[i].state);
							
							qry = std::string("INSERT INTO events (module_id, state, ts) VALUES (") + std::to_string(dat.modules[i].moduleId) + "," + std::to_string(dat.modules[i].state) + ",NOW() )";
							stmt->execute(qry);
							res = stmt->executeQuery("SELECT LAST_INSERT_ID()");
							res->next();
							last_inserted = res->getInt(1);
							
							int j = 0;
							while (j < MAX_SENSORS_X_MODULE && dat.modules[i].sensors[j].sensorType != 0) {
								printf("     . Sensor Type: %d\n",dat.modules[i].sensors[j].sensorType);
								printf("     . Sensor Value: %f\n",dat.modules[i].sensors[j].value);
								
								qry = std::string("INSERT INTO event_sensors (event_id, sensor_type_id, value) VALUES (") + std::to_string(last_inserted) + "," + std::to_string(dat.modules[i].sensors[j].sensorType) + "," + std::to_string(dat.modules[i].sensors[j].value) + ")";
								stmt->execute(qry);

								j++;
							}
							i++;
						}
						
						con->commit();
						
						 break;
					}
					default:  network.read(header,0,0); 
						printf("Rcv bad type %d from 0%o\n",header.type,header.from_node); 
						break;
				}
				
				delete stmt;
				delete con;
			} catch (sql::SQLException &e) {
				cout << "# ERR: SQLException in " << __FILE__;
				cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << endl;
				cout << "# ERR: " << e.what();
				cout << " (MySQL error code: " << e.getErrorCode();
				cout << ", SQLState: " << e.getSQLState() << " )" << endl;
			}
		}
	delay(2);
	}
	return 0;
}