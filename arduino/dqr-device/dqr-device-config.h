/*
 * DqR Device
 * Version: 2.0
 * --- DqR Systems 2017 ---
 */

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

#define MAX_SENSORS_X_MODULES 10
#define MAX_MODULES_X_DEVICES  3
