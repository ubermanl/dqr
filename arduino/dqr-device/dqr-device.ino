/*
 * DqR Device
 * Version: 1.0
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
//#include <Wire.h>  // not sure we are using this.
#include "dqr-device.h"

/*
 * These constants define cabling standards, so that all sensors are ALWAYS cabled in the same way
 * accross the different arduino models. This tells you where each of the digital or analog signal
 * cables go.
 */
#define POT_RELAY_OUT     2
#define POT_AC_SENSOR_IN A2
#define LUX_TOUCH_IN      3
#define LUX_RELAY_OUT     4
#define LUX_AC_SENSOR_IN A3
#define LUX_LUM_SENS_SDA A4   # This one is a default, not passed to the constructor
#define LUX_LUM_SENS_SCL A5   # This one is a default, not passed to the constructor
#define LUX_PIR_SENS_IN   5
#define LUX_SND_SENS_IN  A0
#define RF24_CE    7
#define RF24_CSN   8
#define RF24_MOSI 11
#define RF24_MISO 12 
#define RF24_SCK  13

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

