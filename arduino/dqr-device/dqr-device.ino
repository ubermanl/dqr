/*
 * DqR Device
 * Version: 2.0
 * --- DqR Systems 2017 ---
 */


// Definition of classes
#include "dqr-device.h"

Device dqrDevice;

void setup() {
  Serial.begin(9600);
  dqrDevice.addModule(LUX_TYPE_ID);
  dqrDevice.addModule(POTENTIA_TYPE_ID);

}

void loop() { 
  dqrDevice.getModuleStatus(); 
  delay(1000);
}

