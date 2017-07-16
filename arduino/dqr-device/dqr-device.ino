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
ACSensor luxACSensor(100, luxConfig1.AC_SENSOR_IN);
PIRSensor pirSensor(101, luxConfig1.PIR_SENS_IN);
SoundSensor soundSensor(102, luxConfig1.SND_SENS_IN);
LightSensor lightSensor(103, luxConfig1.LUM_SENS_SDA);

Potentia potentiaModule(potentiaConfig1);
ACSensor potentiaACSensor(104, potentiaConfig1.AC_SENSOR_IN);

/*** Helper Functions ***/
void toggleRelayStatus() {
  Serial.println("Button pressed");
  luxModule.touchEvent();
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

