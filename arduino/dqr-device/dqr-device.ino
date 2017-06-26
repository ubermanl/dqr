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

/*
 * Libraries required by the different sensors
 */
// Definition of classes
#include "dqr-device.h"
// Configutation parameters
#include "dqr-device-config.h"
// Custom network implementation
#include "dqr-device-network.h"


/* TODO
#define TMP_SENSOR_IN     
*/

/*
 * These global variables control device tuning
 */
int luxSensorSensitivity = 100;
int potSensorSensitivity = 100;
unsigned long time = 0;



//Lux luxModule(LUX_RELAY_OUT, LUX_TOUCH_IN);
//Device dqrDevice();
//dqrDevice.add



void setup() {
  Serial.begin(9600);
  
}

void loop() {
  
}

