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

/************************************ Static Configuration and declarations ************************************/

/*
 * Module type ID, must match on Ratio Console Database
 */
#define LUX_TYPE_ID      1
#define POTENTIA_TYPE_ID 2
#define OMNI_TYPE_ID     3

/*
 * Sensor type ID, must match on Ratio Console Database
 */
#define AC_TYPE_ID       1
#define LUM_TYPE_ID      2
#define PIR_TYPE_ID      3
#define SND_TYPE_ID      4
#define TEMP_TYPE_ID     5

/*
 * These constants define max number of sensors per module, and max number of modules per devices
 */
#define MAX_SENSORS_X_MODULE 5
#define MAX_MODULES_X_DEVICE  3

/*
 * Module Configuration Static Structure
 * This variables define the structure for module configuration specified at the end of the file
 */
struct luxConfig {
  byte ID;
  byte TOUCH_IN;
  byte RELAY_OUT;
  byte AC_SENSOR_IN;
  byte LUM_SENS_SDA;
  byte LUM_SENS_SCL;
  byte PIR_SENS_IN;
  byte SND_SENS_IN;
};

struct potentiaConfig {
  byte ID;
  byte RELAY_OUT;
  byte AC_SENSOR_IN;
};

struct omniConfig {
  byte ID;
  byte AC_SENSOR_IN;
  byte LUM_SENS_SDA;
  byte LUM_SENS_SCL;
  byte PIR_SENS_IN;
  byte SND_SENS_IN;
  byte TEMP_SENS_IN;
};

/*
 * Device Finite State Machine Codes
 */
#define DEVICE_PRECONFIGURED 0
#define DEVICE_DISCOVERY 1
#define DEVICE_AWAITINGCONNECTION 2
#define DEVICE_UNMANAGED 3
#define DEVICE_OPERATIONAL 4

/*
 * These define the four possible states of a module, from the FSM perspective
 */
#define MODULE_INACTIVE     0
#define MODULE_ACTIVE       1
#define MODULE_INACTIVE_OVR 2 
#define MODULE_ACTIVE_OVR   3

/*
 * The ammount of seconds a PIR detection window lasts
 */
#define PIR_TIMEOUT_SECONDS 60

/*
 * Sensitivity of the Lux and Potentia AC sensors
 */
const int luxSensorSensitivity = 100;
const int potSensorSensitivity = 100;

/*
 * Relay ON/OFF configuration
 * Default state for modules using relays
 */
#define LUX_RELAY_ON LOW
#define LUX_RELAY_OFF HIGH
#define POTENTIA_RELAY_ON LOW
#define POTENTIA_RELAY_OFF HIGH
#define LUX_DEFAULT_RELAY HIGH
#define POTENTIA_DEFAULT_RELAY LOW

/*
 * Maximum value stored for accumulated sensing
 */
#define MAX_ACCUMULATED_VALUE 4294967295

/************************************ Device Specific Configuration - Module config ************************************/

/*** RF24 Node ID (1-255) ***/
#define DEVICE_NODE_ID 3

// Module ID 3 - Potentia
const struct potentiaConfig potentiaConfig1 = {
  3,    // Module ID
  2,    // POT_RELAY_OUT
  A2    // POT_AC_SENSOR_IN
};

// Module ID 2 - Lux
const struct luxConfig luxConfig1 = {
  5,    // Module ID
  3,    // LUX_TOUCH_IN
  4,    // LUX_RELAY_OUT
  A3,   // LUX_AC_SENSOR_IN
  A4,   // LUX_LUM_SENS_SDA
  A5,   // LUX_LUM_SENS_SCL
  5,    // LUX_PIR_SENS_IN
  A0    // LUX_SND_SENS_IN
};

#endif
