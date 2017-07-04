/*
 * DqR Device
 * Version: 2.0
 * --- DqR Systems 2017 ---
 */


// Definition of classes
#include "dqr-device.h"

/*
 * Device Initialization: This sample configuration has 1x Lux and 1x Potentia module
 */
Device dqrDevice;
Lux luxModule;
ACSensor luxACSensor;
PIRSensor pirSensor;
SoundSensor soundSensor;
LightSensor lightSensor;

Potentia potentiaModule;
ACSensor potentiaACSensor;


void setup() {
  Serial.begin(9600);
  pirSensor.setup(LUX_PIR_SENS_IN);
  soundSensor.setup(LUX_SND_SENS_IN);
  luxACSensor.setup(LUX_AC_SENSOR_IN);
  lightSensor.setup(99);

  luxModule.setup(LUX_RELAY_OUT, LUX_TOUCH_IN);

  dqrDevice.addModule(luxModule);
  potentiaACSensor.setup(POT_AC_SENSOR_IN);
  dqrDevice.addModule(potentiaModule);
}

void loop() { 
  dqrDevice.getModuleStatus(); 
  delay(1000);
}

