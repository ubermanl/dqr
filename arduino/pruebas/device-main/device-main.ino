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

/**** FSM States ****/
State sPreconfigured = State(Device::runPreconfigured);
State sDiscovery = State(Device::runDiscovery);
State sAwaitingConnection = State(Device::runAwaitingConnection);
State sUnmanaged = State(Device::runUnmanaged);
State sOperational = State(Device::runOperational);
FSM devFSM = FSM(sPreconfigured); 

// Arduino Inicialization
void setup() {
  Serial.setTimeout(250);
  Serial.begin(9600);
  Serial.flush();
  Device::setFSM(devFSM, sPreconfigured, sDiscovery, sAwaitingConnection, sUnmanaged, sOperational);
  Device::setMesh(mesh);
  Device::setup();
}

// Arduino operation
void loop(){
  Device::run();
}
