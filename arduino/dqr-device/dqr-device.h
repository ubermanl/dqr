/*
 * DqR Device header of classes
 * Version: 2.0
 * --- DqR Systems 2017 ---
 */
 
#ifndef DqR_h
#define DqR_h

#include "Arduino.h"
#include <BH1750.h>
#include <FiniteStateMachine.h>
#include "dqr-device-config.h"
#include "dqr-device-network.h"


/*** Debugging  ***/
#define DEBUG
#ifdef DEBUG
#define LOG(m) Serial.print(millis()); Serial.print(": "); Serial.println(m);
#define LOG2(m1,m2) Serial.print(millis()); Serial.print(": "); Serial.print(m1); Serial.println(m2);
#else
#define LOG(m)
#define LOG2(m1,m2)
#endif


/*--------------------------------[ Classes ]---------------------------------*/

// Abstract class Sensor implements the different type of sensors
class Sensor {
  public:
    Sensor(byte type, byte pin);
    virtual void setup();
    byte getType() { return _typeId; };
    virtual float getAverageValue();
    virtual void senseData() = 0;
    boolean isUrgentNotification() { return _notifyUrgentValue; };
    void resetUrgentNotification() { _notifyUrgentValue = false; };
  protected:
    byte _typeId;
    float _accumulatedValue;
    float _currentValue;
    long _sampleCount;
    int _pinSensor;
    boolean _notifyUrgentValue = false;
};


// Classes for the different sensors
class ACSensor : public Sensor {
  public:
    ACSensor(byte,int);
    void senseData();
    float getACValue();
  protected:
    int _acSensorSensitivity;
};

class PIRSensor : public Sensor {
  public:
    PIRSensor(byte);
    void senseData();
    float getAverageValue();
  protected:
    uint32_t _timer = 0;
};

class TempSensor : public Sensor {
  public:
    TempSensor(byte);
    void senseData();
  protected:
};

class SoundSensor : public Sensor {
  public:
    SoundSensor(byte);
    void senseData();
  protected:    
};

class LightSensor : public Sensor {
  public:
    LightSensor(byte);
    void setup();
    void senseData();
  private:
    BH1750 _lightSensor;
};


// Module class and the different classes that it implements (Lux, Potentia, Omni)
class Module {
  public:
    Module(byte);
    int getId() { return _id; };
    void setId(byte);
    byte getType() { return _typeId; };
    void getSensorsData(payload_sensor sensors[]);
    byte getState() { return _state; };
    boolean addSensor(Sensor *);
    void setupSensors();
    void setRelayStatus(boolean);
    boolean getRelayStatus();
    virtual void transitionEvent(boolean, boolean);
    virtual boolean setup() = 0;
    void run();
  protected:
    int _id;
    byte _typeId;
    byte _state;
    byte _configuredSensorsSize;
    Sensor * _configuredSensors[MAX_SENSORS_X_MODULE];
    int _pinRelay;
    boolean _relayStatus;
};

class Lux : public Module {
  public:
    Lux(struct luxConfig conf);
    boolean setup();
    void touchEvent();
    void transitionEvent(boolean, boolean);
  private:
    byte _pinTouch;
    struct luxConfig _conf;
    uint32_t _lastTouchTime;
    bool _lastStatus;
};
class Potentia : public Module {
  public:
    Potentia(struct potentiaConfig conf);
    boolean setup();
    void transitionEvent(boolean, boolean);
  private:
    struct potentiaConfig _conf;
};
class Omni : public Module {
  public:
    Omni(struct omniConfig conf);
    boolean setup();
    void transitionEvent(boolean, boolean);
  private:  
    struct omniConfig _conf;
};

// Device class
class Device {
  public:
    /*
     * Device setup initialization
     * Arduino Setup()
     */
    static void setFSM(FSM &fsm, State &pc, State &di, State &aw, State &un, State &op);
    static void setNetwork(RF24Network &network, RF24Mesh &mesh);
    static void setup();

    /*
     * Device Modules operation
     */
    static void setupModules();
    static void getModuleStatus(payload_module modules[]);
    static boolean addModule(Module *);
    
    /*
     * Device continuos operation
     * Arduino Loop()
     */
    static void run();

    /*
     * Preconfigured State Operation
     */
    static void runPreconfigured();
    
    /*
     * Discovery State Operation
     */
    static void runDiscovery();
    
    /*
     * Awaiting Connection State Operation
     */
    static void runAwaitingConnection();
    
    /*
     * Unmanage State Operation
     */
    static void runUnmanaged();
    
    /*
     * Fully Operational State Operation
     */
    static void runOperational();

    /*
     * Send Message to Ratio
     */
    static void sendMessage(const void * data, uint8_t msg_type, size_t size);

  private:
    /*** Variables ***/
    static Module * _configuredModules[MAX_MODULES_X_DEVICE];
    static byte _configuredModulesSize;
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

    /*** Methods ***/
    static int getModuleIndex(uint16_t);
    static void receive();
};

#endif


