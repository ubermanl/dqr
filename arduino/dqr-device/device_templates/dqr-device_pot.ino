/*
   DqR Device
   Version: 2.0
   --- DqR Systems 2017 ---
*/

#include "dqr-device.h"

/*
 *  Device Initialization: This sample configuration has 1x Potentia module
 */
Potentia potentiaModule(potentiaConfig1);
ACSensor potentiaACSensor(potentiaConfig1.AC_SENSOR_IN,POT_SENSOR_SENSITIVITY);

/**** END DEVICE INITIALIZATION ****/


/**** Configure the nrf24l01 CE and CS pins ****/
RF24 radio(RF24_CE, RF24_CSN);
RF24Network network(radio);
RF24Mesh mesh(radio, network);

/**** FSM States ****/
State sPreconfigured = State(Device::runPreconfigured);
State sDiscovery = State(Device::runDiscovery);
State sAwaitingConnection = State(Device::runAwaitingConnection);
State sUnmanaged = State(Device::runUnmanaged);
State sOperational = State(Device::runOperational);
FSM devFSM = FSM(sPreconfigured); 


void setup() {
  Serial.begin(9600);
  Serial.setTimeout(250);
  Serial.flush();

  // Device Initial config
  Device::setFSM(devFSM, sPreconfigured, sDiscovery, sAwaitingConnection, sUnmanaged, sOperational);
  Device::setNetwork(network,mesh);
  Device::setup();

  // Sensors Config
  potentiaModule.addSensor(& potentiaACSensor);

  // Modules Config
  Device::addModule(& potentiaModule);
  Device::setupModules();

  LOG2("Device ID: #",DEVICE_NODE_ID);
}

void loop() {
  
  Device::run();

}

