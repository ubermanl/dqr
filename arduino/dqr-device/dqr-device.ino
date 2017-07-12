/*
   DqR Device
   Version: 2.0
   --- DqR Systems 2017 ---
*/


// Definition of classes
#include "dqr-device.h"

/*
   Device Initialization: This sample configuration has 1x Lux and 1x Potentia module
*/
Device dqrDevice;
Lux luxModule;
ACSensor luxACSensor;
PIRSensor pirSensor;
SoundSensor soundSensor;
LightSensor lightSensor;

Potentia potentiaModule;
ACSensor potentiaACSensor;

void toggleRelayStatus() {
  Serial.println("Button pressed");
  //luxModule.toggleRelayStatus();
}


void setup() {
  Serial.begin(9600);
/*
  // setup Lux and Potentia Modules
  luxModule.setup(LUX_RELAY_OUT, LUX_TOUCH_IN);
  potentiaModule.setup(POT_RELAY_OUT);

  // setup Lux sensors
  pirSensor.setup(LUX_PIR_SENS_IN);
  soundSensor.setup(LUX_SND_SENS_IN);
  luxACSensor.setup(LUX_AC_SENSOR_IN);
  lightSensor.setup(99);

  // setup Potentia sensors
  potentiaACSensor.setup(POT_AC_SENSOR_IN);

  // Finally, add modules to DqR device
  dqrDevice.addModule(luxModule);
  dqrDevice.addModule(potentiaModule);
*/
  attachInterrupt(digitalPinToInterrupt(LUX_TOUCH_IN), toggleRelayStatus, RISING);

}

void loop() {

  module_t modules[MAX_MODULES_X_DEVICE];
  dqrDevice.getModuleStatus(modules);

}

