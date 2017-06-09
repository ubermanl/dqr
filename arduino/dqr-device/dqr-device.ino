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
#define LUX_LUM_SENS_SDA A4   # This one is a default, not passed to the Lux constructor
#define LUX_LUM_SENS_SCL A5   # This one is a default, not passed to the Lux constructor
#define LUX_PIR_SENS_IN   5
#define LUX_SND_SENS_IN  A0
#define LUX_PRESENCE_OUT 12
/* TODO
#define TMP_SENSOR_IN     
*/

/*
 * These global variables control device tuning
 */
int luxSensorSensitivity = 100;
int potSensorSensitivity = 100;
unsigned long time = 0;

Lux luxDevice(LUX_RELAY_OUT, LUX_AC_SENSOR_IN, luxSensorSensitivity, LUX_TOUCH_IN, LUX_SND_SENS_IN, LUX_PIR_SENS_IN);
Pot potDevice(POT_RELAY_OUT, POT_AC_SENSOR_IN, potSensorSensitivity);


void setup() {
  if (LUX == true) luxDevice.setup();
  if (POT == true) potDevice.setup();
  
  Serial.begin(9600);
  Serial.println("time,lum,snd,pir,luxamps,luxrelay");
}

void loop() {
  // Timers are used so that data can be gathered at different intervals
  // TODO: replace with the timer library
  time = millis();
  unsigned int everySecond = time % 1000;
  unsigned int everyFiveSeconds = time % 5000;
  unsigned int everyTenSeconds = time % 10000;
  unsigned int everyOneMinute = time % 60000;
  unsigned int everyTenMinutes = time % 600000;
  unsigned int everyOneHour = time % 3600000;

  // Override operation
  if (luxDevice.getTouchStatus() == HIGH) luxDevice.setRelayStatus(!luxDevice.getRelayStatus());
  
  if (everySecond == 0) {
    Serial.print(time);
    Serial.print(": ");
    Serial.print(luxDevice.getLumValue());
    Serial.print(" | ");
    Serial.print(luxDevice.getSoundValue());
    Serial.print(" | ");
    Serial.print(luxDevice.getPirStatus());
    Serial.print(" | ");
    Serial.print(luxDevice.getAcValue());
    Serial.print(" | ");
    Serial.print(luxDevice.getRelayStatus());
    Serial.println("");

  }
  if (everyTenSeconds == 0) {
    Serial.println("");
    Serial.println("time,lum,snd,pir,luxamps,luxrelay");
  }
}

