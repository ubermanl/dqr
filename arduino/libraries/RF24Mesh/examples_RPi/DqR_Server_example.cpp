#include "RF24Mesh/RF24Mesh.h"  
#include <RF24/RF24.h>
#include <RF24Network/RF24Network.h>

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
  byte moduleId[MAX_MODULES_X_DEVICE];
  byte sensorId[MAX_SENSORS_X_MODULE];
};
struct __attribute__ ((__packed__)) payload_sensor {
  byte sensorId = 0;
  //byte value[4] = { 0, 0, 0, 0 };
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



/*
union float_t {
   unsigned char part[4];
   float number;
};
*/


/**************************************** GLOBAL VARIABLES ****************************************/
RF24 radio(RPI_V2_GPIO_P1_15, BCM2835_SPI_CS0, BCM2835_SPI_SPEED_8MHZ);  
RF24Network network(radio);
RF24Mesh mesh(radio,network);



/**************************************** MAIN ****************************************/
int main(int argc, char** argv) {
  
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
			
			switch(header.type) {
				case 'I': {
					payload_I dat;
					network.read(header,&dat,sizeof(dat)); 
					printf("Rcv data from 0%o\n",header.from_node);
					printf(" - Device Id: %d\n",dat.deviceId);
					int i = 0;
					while (i < MAX_MODULES_X_DEVICE && dat.modules[i].moduleId != 0) {
					//while (i < MAX_MODULES_X_DEVICE) {
						printf("   . Module Id: %d\n",dat.modules[i].moduleId);
						printf("   . Module State: %d\n",dat.modules[i].state);
						int j = 0;
						while (j < MAX_SENSORS_X_MODULE && dat.modules[i].sensors[j].sensorId != 0) {
						//while (j < MAX_SENSORS_X_MODULE) {
							printf("     . Sensor Id: %d\n",dat.modules[i].sensors[j].sensorId);
							/*
							float_t temp;
							for (int n=0; n < 4; n++) {
								temp.part[n] = dat.modules[i].sensors[j].value[n];
								//printf("     . Sensor Value (%d): %d\n",n,temp.part[n]);
							}
							*/
							printf("     . Sensor Value (Float): %f\n",dat.modules[i].sensors[j].value);

							j++;
						}
						i++;
					}
					 break;
				}
				default:  network.read(header,0,0); 
					printf("Rcv bad type %d from 0%o\n",header.type,header.from_node); 
					break;
			}
		}
	delay(2);
	}
	return 0;
}