/*
   DqR Device
   Version: 2.0
   --- DqR Systems 2017 ---
*/

#include "dqr-device.h"

/*
 *  Device Initialization: This sample configuration has 1x Lux and 1x Potentia module
 */
Omni omniModule(omniConfig1);
ACSensor omniACSensor(omniConfig1.AC_SENSOR_IN,OMNI_SENSOR_SENSITIVITY);
PIRSensor pirSensor(omniConfig1.PIR_SENS_IN);
SoundSensor soundSensor(omniConfig1.SND_SENS_IN);
LightSensor lightSensor(omniConfig1.LUM_SENS_SDA);
TempSensor tempSensor(omniConfig1.TEMP_SENS_IN);
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
  omniModule.addSensor(& omniACSensor);
  omniModule.addSensor(& pirSensor);
  omniModule.addSensor(& soundSensor);
  omniModule.addSensor(& lightSensor);
  omniModule.addSensor(& tempSensor);

  // Modules Config
  Device::addModule(& omniModule);
  Device::setupModules();

  LOG2("Device ID: #",DEVICE_NODE_ID);
}

void loop() {
  
  Device::run();

}

