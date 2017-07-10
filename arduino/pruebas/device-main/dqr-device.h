#include <Arduino.h>
#include <SPI.h>
#include <FiniteStateMachine.h>
#include "RF24.h"
#include "RF24Network.h"
#include "RF24Mesh.h"


/*** CONFIG ***/
#define MAX_SENSORS_X_MODULE 5
#define MAX_MODULES_X_DEVICE  3


/*** RF24 Node ID (1-255) ***/
#define DEVICE_NODE_ID 2

/*** Device FSM State Codes ***/
#define DEVICE_PRECONFIGURED 0
#define DEVICE_DISCOVERY 1
#define DEVICE_AWAITINGCONNECTION 3
#define DEVICE_UNMANAGED 4
#define DEVICE_OPERATIONAL 5

/*** Debugging  ***/
#define DEBUG
#ifdef DEBUG
#define LOG(m) Serial.println(m);
#define LOG2(m1,m2) Serial.print(m1); Serial.println(m2);
#else
#define LOG(m)
#define LOG2(m1,m2)
#endif

/*** Communication Protocol ***/
#define REQUEST_MESSAGE 'S'
#define INFORM_MESSAGE 'I'
#define ACTION_MESSAGE 'A'
#define S_SUBTYPE_ALL 0
#define S_SUBTYPE_STATE 1
#define S_SUBTYPE_SENSOR 2
enum S_subtype { all = S_SUBTYPE_ALL, state = S_SUBTYPE_STATE, sensor = S_SUBTYPE_SENSOR };

typedef struct {
  S_subtype subtype;
  byte moduleId[MAX_MODULES_X_DEVICE];
  byte sensorId[MAX_SENSORS_X_MODULE];
} payload_S;
typedef struct {
  byte sensorId = 0;
  byte value1 = 0;
  byte value2 = 0;
} payload_sensor;
typedef struct {
  byte moduleId = 0;
  byte state = 0;
  payload_sensor sensors[MAX_SENSORS_X_MODULE];
} payload_module;
typedef struct {
  byte deviceId = 0;
  payload_module modules[MAX_MODULES_X_DEVICE];
} payload_I;
typedef struct {
  byte desiredState;
  byte moduleId;
} payload_A;


class Device {
	private:
		/* A MERGEAR
		int _configuredModules[10];
		....
		 void addModule();	// A mergear
		 */
		 
		/**
		 * Variables
		 */
		static State * _sPreconfigured;
		static State * _sDiscovery;
		static State * _sAwaitingConnection;
		static State * _sUnmanaged;
		static State * _sOperational;
		static FSM * _devFSM;
		static byte _currentState;
		static uint32_t _timer;
    static RF24Network * _network;
    static RF24Mesh * _mesh;

    static void sendMessage(const void * data, uint8_t msg_type, size_t size);
    static void receive();

	public:   
		/**
		 * Device setup initialization
		 * Arduino Setup()
		 */
		static void setFSM(FSM &fsm, State &pc, State &di, State &aw, State &un, State &op);
    static void setNetwork(RF24Network &network, RF24Mesh &mesh);
    static void setup();
		
		/**
		 * Device continuos operation
		 * Arduino Loop()
		 */
		static void run();

    /**
     * Preconfigured State Operation
     */
    static void runPreconfigured();
    
    /**
     * Discovery State Operation
     */
    static void runDiscovery();
    
    /**
     * Awaiting Connection State Operation
     */
    static void runAwaitingConnection();
    
    /**
     * Unmanage State Operation
     */
    static void runUnmanaged();
    
    /**
     * Fully Operational State Operation
     */
    static void runOperational();
};
