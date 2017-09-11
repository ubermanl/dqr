/*
   DqR Device
   Version: 2.0
   --- DqR Systems 2017 ---
*/

#include "dqr-device.h"

/*
 *  Device Initialization: This sample configuration has 1x Lux and 1x Potentia module
 */
Lux luxModule(luxConfig1);
ACSensor luxACSensor(luxConfig1.AC_SENSOR_IN);
PIRSensor pirSensor(luxConfig1.PIR_SENS_IN);
SoundSensor soundSensor(luxConfig1.SND_SENS_IN);
LightSensor lightSensor(luxConfig1.LUM_SENS_SDA);

Potentia potentiaModule(potentiaConfig1);
ACSensor potentiaACSensor(potentiaConfig1.AC_SENSOR_IN);

/*** Helper Functions ***/
unsigned long lastChange = 0;
void toggleRelayStatus() {
  LOG2("Button pressed for Module #",luxModule.getId());
  if ((millis() - lastChange) > 100) {
    luxModule.touchEvent();
    lastChange = millis();
  }
}



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
  luxModule.addSensor(& luxACSensor);
  luxModule.addSensor(& pirSensor);
  luxModule.addSensor(& soundSensor);
  luxModule.addSensor(& lightSensor);
  potentiaModule.addSensor(& potentiaACSensor);

  // Modules Config
  Device::addModule(& luxModule);
  Device::addModule(& potentiaModule);
  Device::setupModules();

  /**** CONFIG: Interruptions for Lux Modules ****/
  attachInterrupt(digitalPinToInterrupt(luxConfig1.TOUCH_IN), toggleRelayStatus, RISING);

  LOG2("Device ID: #",DEVICE_NODE_ID);
}

void loop() {
  
  Device::run();


  /*************** TODO LO QUE ESTA ACA ES PARA PROBAR Y SE PUEDE BORRAR *************************/
  /*
  // Agregado para probar activacion del LUX por SERIAL
  if (Serial.available() > 0) {
    Serial.print("Processing messages...");
    String msg = Serial.readString();
    if ( msg == "ON") {
      luxModule.setDesiredState(true);
    } else if (msg == "OFF") {
      luxModule.setDesiredState(false);
    }
    Serial.println(" Complete!");
  }
  */

 /*************** TODO LO QUE ESTA ACA ES PARA PROBAR Y SE PUEDE BORRAR *************************/
}

