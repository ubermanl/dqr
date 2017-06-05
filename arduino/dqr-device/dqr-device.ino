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
#include <Wire.h>
#include <BH1750.h>
//#include "dqr-device.h"

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
#define LUX_LUM_SENS_SDA A4
#define LUX_LUM_SENS_SCL A5
#define LUX_PIR_SENS_IN   5
#define LUX_SND_SENS_IN  A0
#define LUX_PRESENCE_OUT 12
/* TODO
#define PIR_SENSOR_IN     
#define SND_SENSOR_IN     
#define TMP_SENSOR_IN     
*/

/*
 * These global variables control device tuning
 * 
 */
boolean luxTouchLast = false;
boolean luxRelayState = true;

int luxSensorSensitivity = 100;
int luxNoiseSteps = 0;
BH1750 lightSensor;

boolean potRelayState = true;
int potNoiseSteps = 0;

unsigned long time = 0;


/*
 * Global function definitions: All funtions should go here, regardless of the DqR device they are meant for
 * 
 */

// Update LUX relay state comparing last and current states of the touch sensor
boolean setLuxRelayState(boolean touchLast, boolean touchCurrent) {
  if (touchCurrent && touchCurrent != touchLast ) {
    luxRelayState = !luxRelayState;
    digitalWrite(LUX_RELAY_OUT, luxRelayState);
  }
  return touchCurrent;
}

/* 
 *  This function reports the maximum value of a current sensor during a period of time.
 *    sensor: the id of the sensor, could be the pin of lux or potentia
 *    periodNumber: The number of 20ms periods that will be analized
 */
int getCurrentValue(int sensor, int periodNumber){
  double startTime = millis();
  int max = 0;
  int min = 1023;
  int rVal = 0;
  while ((millis() - startTime) < 20*periodNumber) {
    rVal = analogRead(sensor);
    if (rVal > max) {
      max = rVal;
    }
    if (rVal < min) {
      min = rVal;
    }
  }
  return (max - min);
}

double currentStepsToAmps(double steps, int sensorSensitivity) {
  // The number of steps is multiplied by 5 and divided by 1024 to convert to volts
  // Then the number of volts is multiplied by 100 to convert to milivolts, and divided by the sensor sensitivity
  if (steps <= 7) steps = 0;
  double Vrms = ((steps * 5/1024) / 2) * sqrt(2)/2;
  return Vrms * 1000/sensorSensitivity;
  
}

double getSoundStatus() {
  return analogRead(LUX_SND_SENS_IN);
}


boolean getPirStatus() {
  return digitalRead(LUX_PIR_SENS_IN);
  int startTime = millis();
  while ((millis() - startTime < 100)) {
    if (digitalRead(LUX_PIR_SENS_IN) == HIGH) {
      return HIGH;
    }
  }
  return LOW;
}
/*
 * 
 */
void setup() {
  Serial.begin(9600);
  
  if ( LUX == true ) {
    pinMode(LUX_TOUCH_IN, INPUT);
    pinMode(LUX_RELAY_OUT, OUTPUT);
    pinMode(LUX_PIR_SENS_IN, INPUT);
    pinMode(LUX_SND_SENS_IN, INPUT);
    digitalWrite(LUX_PIR_SENS_IN, LOW);
    pinMode(LUX_PRESENCE_OUT, OUTPUT);
    
    digitalWrite(LUX_RELAY_OUT, luxRelayState);
    luxNoiseSteps = getCurrentValue(LUX_AC_SENSOR_IN, 10);
    lightSensor.begin(BH1750_CONTINUOUS_HIGH_RES_MODE_2);
  }
  
  if ( POT == true ) {
    pinMode(POT_RELAY_OUT, OUTPUT);
    digitalWrite(LUX_RELAY_OUT, potRelayState);
    //potCurrentZero = getCurrentValue(POT_AC_SENSOR_IN, 10, 0);
  }
  
  if ( OMNI == true ) {
  }

  Serial.println("lum,snd,pir,luxamps,luxrelay");
}


/*
 * Device's main loop
 */
void loop() {
  double luxCurrentValue;
  unsigned int luxLightValue;
  bool pirStatus;
  double sndStatus;
  
  // Timers are used so that data can be gathered at different intervals
  time = millis();
  unsigned int everySecond = time % 1000;
  unsigned int everyFiveSeconds = time % 5000;
  unsigned int everyTenSeconds = time % 10000;
  unsigned int everyOneMinute = time % 60000;
  unsigned int everyTenMinutes = time % 600000;
  unsigned int everyOneHour = time % 3600000;
  
  // Collect AC data
  if (everySecond == 0) {
    luxCurrentValue = currentStepsToAmps(getCurrentValue(LUX_AC_SENSOR_IN, 10), luxSensorSensitivity);
  }

  // Collect luminosity data
  if (everySecond == 0) {
    luxLightValue = lightSensor.readLightLevel();
  }

  // Collect presence data
  if (everySecond == 0) {
    pirStatus = getPirStatus();
  }

  // Collect sound sensor
  if (everySecond == 0) {
    sndStatus = getSoundStatus();
  }

  // Collect temperature data

  // Collect touch status and update Lux relay, if needed
  luxTouchLast = setLuxRelayState(luxTouchLast, digitalRead(LUX_TOUCH_IN));
  
  // print overall status (send over network in the future)
  if (everyTenSeconds == 0) {
    Serial.println("");
    Serial.println("lum,snd,pir,luxamps,luxrelay");
  }
  if (everySecond == 0) {
    Serial.print(luxLightValue);
    Serial.print(",");
    Serial.print(sndStatus);
    Serial.print(",");
    Serial.print(pirStatus);
    Serial.print(",");
    Serial.print(luxCurrentValue);
    Serial.print(",");
    Serial.print(! luxRelayState);
    Serial.println("");

    if (pirStatus || sndStatus) {
      digitalWrite(LUX_PRESENCE_OUT, HIGH);

    } else {
      digitalWrite(LUX_PRESENCE_OUT, LOW);
    }
  }
}
