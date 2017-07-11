 
 
 /** RF24Mesh_Example_Master.ino by TMRh20
  * 
  * Note: This sketch only functions on -Arduino Due-
  *
  * This example sketch shows how to manually configure a node via RF24Mesh as a master node, which
  * will receive all data from sensor nodes.
  *
  * The nodes can change physical or logical position in the network, and reconnect through different
  * routing nodes as required. The master node manages the address assignments for the individual nodes
  * in a manner similar to DHCP.
  *
  */
  
#include "RF24Mesh/RF24Mesh.h"  
#include <RF24/RF24.h>
#include <RF24Network/RF24Network.h>


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

typedef struct {
  S_subtype subtype;
  byte moduleId[MAX_MODULES_X_DEVICE];
  byte sensorId[MAX_SENSORS_X_MODULE];
} payload_S;
typedef struct {
  byte sensorId = 0;
  unsigned char value[4];
} payload_sensor;
typedef struct {
  byte moduleId = 0;
  byte state = 0;
  payload_sensor sensors[MAX_SENSORS_X_MODULE];
} payload_module;
typedef struct {
  byte deviceId = 0;
  payload_module modules[MAX_MODULES_X_DEVICE];
} payload_I;
typedef struct {
  byte desiredState;
  byte moduleId;
} payload_A;

union float_t {
   unsigned char part[4];
   float number;
};


/*** Sensors Outputs ***/
/**** 
 - Luz: 0-1024 => /4
 - Sonido:
 - Corriente: 
****/


RF24 radio(RPI_V2_GPIO_P1_15, BCM2835_SPI_CS0, BCM2835_SPI_SPEED_8MHZ);  
RF24Network network(radio);
RF24Mesh mesh(radio,network);



int main(int argc, char** argv) {
  
  // Set the nodeID to 0 for the master node
  mesh.setNodeID(0);
  // Connect to the mesh
  printf("start\n");
  mesh.begin();
  radio.printDetails();

while(1)
{
  
  // Call network.update as usual to keep the network updated
  mesh.update();

  // In addition, keep the 'DHCP service' running on the master node so addresses will
  // be assigned to the sensor nodes
  mesh.DHCP();
  
  
  // Check for incoming data from the sensors
  while(network.available()){
//    printf("rcv\n");
    RF24NetworkHeader header;
    network.peek(header);
    
    //uint32_t dat=0;
    switch(header.type){
      // Display the incoming millis() values from the sensor nodes
      case 'I': 
	  {
				payload_I dat;
				network.read(header,&dat,sizeof(dat)); 
                //printf("Rcv %u from 0%o\n",dat,header.from_node);
				printf("Rcv data from 0%o\n",header.from_node);
				printf(" - Device Id: %d\n",dat.deviceId);
				int i = 0;
				//while (i < MAX_MODULES_X_DEVICE && dat.modules[i].moduleId != 0) {
				while (i < MAX_MODULES_X_DEVICE) {
					printf("   . Module Id: %d\n",dat.modules[i].moduleId);
					printf("   . Module State: %d\n",dat.modules[i].state);
					int j = 0;
					//while (j < MAX_SENSORS_X_MODULE && dat.modules[i].sensors[j].sensorId != 0) {
					while (j < MAX_SENSORS_X_MODULE) {
						printf("     . Sensor Id: %d\n",dat.modules[i].sensors[j].sensorId);
						float_t temp;
						for (int n=0; n < 4; n++) {
							temp.part[n] = dat.modules[i].sensors[j].value[n];
							//printf("     . Sensor Value (%d): %d\n",n,temp.part[n]);
						}
					    printf("     . Sensor Value (Float): %f\n",temp.number);

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