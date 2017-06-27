/*
 * DqR Device
 * Version: 2.0
 * --- DqR Systems 2017 ---
 */

/*
 * This controls whether this DqR device will be lux, potentia, omni, or a combination of them.
 * You need to enable or disable functions depending on the hardware configuration of the device
 * where you will be uploading the code. Just switch between TRUE and FALSE as needed.
 */
boolean LUX = true;
boolean POT = false;
boolean OMNI = false;

// Configutation parameters
#include "dqr-device-config.h"

// Definition of classes
#include "dqr-device.h"

// Custom network implementation
#include "dqr-device-network.h"


/*
 * These global variables control device tuning
 */
int luxSensorSensitivity = 100;
int potSensorSensitivity = 100;


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

