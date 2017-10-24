#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <stdlib.h>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <unistd.h>
#include <fcntl.h>

/*** Includes RF24 ***/
#include <RF24Mesh/RF24Mesh.h>
#include <RF24/RF24.h>
#include <RF24Network/RF24Network.h>

/*** Includes MySQL ***/
#include "mysql_connection.h"
#include <mysql_driver.h>
#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <cppconn/prepared_statement.h>

/*** Includes Listener ***/
#include "dqrListener.h"

/**************************************** STATIC CONFIGURATION ****************************************/
/*** Configuration Constants ***/
#define MAX_SENSORS_X_MODULE 5
#define MAX_MODULES_X_DEVICE  3
#define MAX_MESH_WRITE_RETRIES 1

/*** Communication Protocol ***/
#define byte uint8_t
#define REQUEST_MESSAGE 'S'
#define INFORM_MESSAGE 'I'
#define ACTION_MESSAGE 'A'
#define S_SUBTYPE_ALL 0
#define S_SUBTYPE_STATE 1
#define S_SUBTYPE_SENSOR 2
enum S_subtype { all = S_SUBTYPE_ALL, state = S_SUBTYPE_STATE, sensor = S_SUBTYPE_SENSOR };
struct __attribute__ ((__packed__)) payload_S {
  S_subtype subtype;
  uint16_t modules[MAX_MODULES_X_DEVICE];
  byte sensors[MAX_SENSORS_X_MODULE];
};
struct __attribute__ ((__packed__)) payload_sensor {
  byte sensorType = 0;
  float value;
};
struct __attribute__ ((__packed__)) payload_module {
  uint16_t moduleId = 0;
  byte state = 0;
  payload_sensor sensors[MAX_SENSORS_X_MODULE];
};
struct __attribute__ ((__packed__)) payload_I {
  byte deviceId = 0;
  payload_module modules[MAX_MODULES_X_DEVICE];
};
struct __attribute__ ((__packed__)) payload_A {
  bool desiredState;
  bool overrideSet;
  uint16_t moduleId;
};


/*** Mysql DB Config ***/
#define DB_HOST "localhost"
#define DB_USER "root"
#define DB_PASS "root"
#define DB_SCHEMA "ratio_dev"

