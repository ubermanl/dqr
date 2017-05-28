/*
 * DqR Lux
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
 * These constants define cabling standards, so that all sensors are ALWAYS cabled in the same way
 * accross the different arduino models. This tells you where each of the digital or analog signal
 * cables go.
 */
#define POT_RELAY_OUT     2
#define POT_AC_SENSOR_IN A2
#define LUX_TOUCH_IN      3
#define LUX_RELAY_OUT     4
#define LUX_AC_SENSOR_IN A4
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
int luxCurrentZero = 511;

boolean potRelayState = true;
int potCurrentZero = 511;

unsigned long time = 0;


/*
 * Global function definitions: All funtions should go here, regardless of the DqR device they are meant for
 * 
 */

// Update LUX relay state comparing last and current states of the touch sensor
boolean setLuxRelay(boolean touchLast, boolean touchCurrent) {
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
 *    iZero: The current zero of the sensor, which should be close to 511   
 */
int getCurrentValue(int sensor, int periodNumber, int iZero){
  double startTime = millis();
  int max = 0;
  int rVal = 0;
  while ((millis() - startTime) < 20*periodNumber) {
    rVal = analogRead(sensor);
    if (rVal > max) {
      max = rVal;
    }
  }
  return abs(max - iZero);
}

/*
 * 
 */
void setup() {
  Serial.begin(9600);

  if ( LUX == true ) {
    pinMode(LUX_TOUCH_IN, INPUT);
    pinMode(LUX_RELAY_OUT, OUTPUT);
    digitalWrite(LUX_RELAY_OUT, luxRelayState);
    luxCurrentZero = getCurrentValue(LUX_AC_SENSOR_IN, 10, 0);
  }
  
  if ( POT == true ) {
    pinMode(POT_RELAY_OUT, OUTPUT);
    digitalWrite(LUX_RELAY_OUT, potRelayState);
    potCurrentZero = getCurrentValue(POT_AC_SENSOR_IN, 10, 0);
  }
  
  if ( OMNI == true ) {
  }
}


/*
 * Device's main loop
 */
void loop() {
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
    double luxCurrentValue = getCurrentValue(LUX_AC_SENSOR_IN, 10, luxCurrentZero);
    luxCurrentValue = luxCurrentValue * 50/1024;  // * 5/1024 to pass steps to volts, then *1000 to pass volts to milivolts, then /100 which is the sensor sensitivity
    Serial.println(luxCurrentValue);
  }

  // Collect luminosity data
  
  // Collect sound sensor

  // Collect presence data

  // Collect temperature data

  // Collect touch status and update Lux relay, if needed
  luxTouchLast = setLuxRelay(luxTouchLast, digitalRead(LUX_TOUCH_IN));

}
