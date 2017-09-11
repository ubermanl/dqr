/*
 * DqR Device Network Declarations
 * Version: 2.0
 * --- DqR Systems 2017 ---
 */

#include "RF24.h"
#include "RF24Network.h"
#include "RF24Mesh.h"

/*
 * Communication Declarations:
 * RF24 Wireless Module Pin Setup
 */
#define RF24_CE    7
#define RF24_CSN   8
#define RF24_MOSI 11
#define RF24_MISO 12 
#define RF24_SCK  13

/*
 * Communication Declarations:
 * Messaging Protocol
 */
#define REQUEST_MESSAGE 'S'
#define INFORM_MESSAGE 'I'
#define ACTION_MESSAGE 'A'
#define S_SUBTYPE_ALL 0
#define S_SUBTYPE_STATE 1
#define S_SUBTYPE_SENSOR 2
enum S_subtype { all = S_SUBTYPE_ALL, state = S_SUBTYPE_STATE, sensor = S_SUBTYPE_SENSOR };
struct __attribute__ ((__packed__)) payload_S {
  S_subtype subtype;
  int modules[MAX_MODULES_X_DEVICE];
  byte sensors[MAX_SENSORS_X_MODULE];
};
struct __attribute__ ((__packed__)) payload_sensor {
  byte sensorType = 0;
  float value;
};
struct __attribute__ ((__packed__)) payload_module {
  int moduleId = 0;
  byte state = 0;
  payload_sensor sensors[MAX_SENSORS_X_MODULE];
};
struct __attribute__ ((__packed__)) payload_I {
  byte deviceId = 0;
  payload_module modules[MAX_MODULES_X_DEVICE];
};
struct __attribute__ ((__packed__)) payload_A {
  byte desiredState;
  int moduleId;
};


/*
 * Send to Ratio Notification period in seconds
 */
 #define SEND_TO_RATIO_PERIOD 10
