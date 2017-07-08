/*
 * DqR Lux
 * Version: 1.0
 * --- Dqr Systems 2017 ---
 */

#include "dqr-device.h"

// Constants


// Global Variables
/**** Configure the nrf24l01 CE and CS pins ****/
RF24 radio(7, 8);
RF24Network network(radio);
RF24Mesh mesh(radio, network);

Device* dqrDevice = Device::getInstance();

/**** FSM States ****/
State sPreconfigured = State(dqrDevice->runPreconfigured);
State sDiscovery = State(dqrDevice->runDiscovery);
State sAwaitingConnection = State(dqrDevice->runAwaitingConnection);
State sUnmanaged = State(dqrDevice->runUnmanaged);
State sOperational = State(dqrDevice->runOperational);
FSM devFSM = FSM(sPreconfigured); 

// Arduino Inicialization
void setup() {
  Serial.setTimeout(250);
  Serial.begin(9600);
  Serial.flush();
  dqrDevice->setFSM(devFSM, sPreconfigured, sDiscovery, sAwaitingConnection, sUnmanaged, sOperational);
  dqrDevice->setMesh(mesh);
  dqrDevice->setup();
}

// Arduino operation
void loop(){
  dqrDevice->run();
}
