/*
 * DqR Device
 * Version: 2.0
 * --- DqR Systems 2017 ---
 */
#ifndef DqR_conf
#define DqR_conf

/*
 * These constants define cabling standards, so that all sensors are ALWAYS cabled in the same way
 * accross the different arduino models. This tells you where each of the digital or analog signal
 * cables go.
 */

// Device Types
#define LUX_TYPE_ID      1
#define POTENTIA_TYPE_ID 2
#define OMNI_TYPE_ID     3

// Potentia
#define POT_RELAY_OUT     2
#define POT_AC_SENSOR_IN A2

// Lux
#define LUX_TOUCH_IN 3
#define LUX_RELAY_OUT     4
#define LUX_AC_SENSOR_IN A3
#define LUX_LUM_SENS_SDA A4   # This one is a default, not passed to the constructor
#define LUX_LUM_SENS_SCL A5   # This one is a default, not passed to the constructor
#define LUX_PIR_SENS_IN   5
#define LUX_SND_SENS_IN  A0

// RF24 module
#define RF24_CE    7
#define RF24_CSN   8
#define RF24_MOSI 11
#define RF24_MISO 12 
#define RF24_SCK  13


/*
 * These constants define max number of sensors per module, and max number of modules per devices
 */
#define MAX_SENSORS_X_MODULE 10
#define MAX_MODULES_X_DEVICE  3

/*
 * These define the four possible states of a module, from the FSM perspective
 */
#define MODULE_INACTIVE     0
#define MODULE_ACTIVE       1
#define MODULE_INACTIVE_OVR 2 
#define MODULE_ACTIVE_OVR   3


/*
 * The ammount of seconds a PIR detection window lasts
 * 
 */
#define PIR_TIMEOUT_SECONDS 60

/*
 * Sensitivity of the Lux and Potentia AC sensors
 * 
 */
const int luxSensorSensitivity = 100;
const int potSensorSensitivity = 100;


#endif
