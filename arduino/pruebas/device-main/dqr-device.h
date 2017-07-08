#include <Arduino.h>
#include <SPI.h>
#include <FiniteStateMachine.h>
#include "RF24.h"
#include "RF24Network.h"
#include "RF24Mesh.h"

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
    static RF24Mesh * _network;

	public:   
		/**
		 * Device setup initialization
		 * Arduino Setup()
		 */
		static void setFSM(FSM &fsm, State &pc, State &di, State &aw, State &un, State &op);
    static void setMesh(RF24Mesh &mesh);
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
