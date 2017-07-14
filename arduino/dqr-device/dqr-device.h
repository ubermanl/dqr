/*
 * DqR Device header of classes
 * Version: 2.0
 * --- DqR Systems 2017 ---
 */
 
#ifndef DqR_h
#define DqR_h

#include "Arduino.h"
#include <BH1750.h>
#include "dqr-device-config.h"

/*** Debugging  ***/
#define DEBUG
#ifdef DEBUG
#define LOG(m) Serial.println(m);
#define LOG2(m1,m2) Serial.print(m1); Serial.println(m2);
#else
#define LOG(m)
#define LOG2(m1,m2)
#endif


/*----------------------------[ Data Structures ]-----------------------------*/
struct sensor_t {
  byte sensorId = 0;
  byte sensorType;
  float avgValue;
};

struct module_t {
  byte moduleId = 0;
  byte moduleType;
  sensor_t sensors[MAX_SENSORS_X_MODULE];
  byte state;
};

/*--------------------------------[ Classes ]---------------------------------*/

// class Sensor implements the different type of sensors
class Sensor {
  public:
    Sensor(byte id, byte type, byte pin);
    virtual void setup();
    byte getId() { return _id; };
    byte getType() { return _typeId; };
    virtual float getAverageValue();
    virtual void senseData() = 0;
    void setPin(int);
  protected:
    byte _id;
    byte _typeId;
    float _accumulatedValue;
    float _currentValue;
    int _sampleCount;
    int _pinSensor;
};


// Abstract classes for the different sensors
class ACSensor : public Sensor {
  public:
    ACSensor(byte, byte);
    void senseData();
    float getACValue();
  protected:
    int _acSensorSensitivity;
};

class PIRSensor : public Sensor {
  public:
    PIRSensor(byte, byte);
    void senseData();
    float getAverageValue();
  protected:
    uint32_t _timer = 0;
};

class TempSensor : public Sensor {
  public:
    TempSensor(byte, byte);
    void senseData();
  protected:
};

class SoundSensor : public Sensor {
  public:
    SoundSensor(byte, byte);
    void senseData();
  protected:    
};

class LightSensor : public Sensor {
  public:
    LightSensor(byte, byte);
    void setup();
    void senseData();
  private:
    BH1750 _lightSensor;
};


// Module class and the different classes that it implements (Lux, Potentia, Omni)
class Module {
  public:
    Module(byte, byte);
    byte getId() { return _id; };
    byte getType() { return _typeId; };
    void getSensorsData(sensor_t sensors[]);
    byte getState() { return _relayStatus; }; // TODO: Cambiar esto a FSM
    boolean addSensor(Sensor *);
    void setupSensors();
    void setRelayStatus(boolean);
    boolean getRelayStatus();
    void toggleRelayStatus();
    virtual boolean setup() = 0;
    void run();
  protected:
    byte _id;
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
    byte getPinTouch() { return _pinTouch; }; 
  private:
    byte _pinTouch;
    struct luxConfig _conf;
};
class Potentia : public Module {
  public:
    Potentia(struct potentiaConfig conf);
    boolean setup();
  private:
    struct potentiaConfig _conf;
};
class Omni : public Module {
  public:
    Omni(struct omniConfig conf);
    boolean setup();
  private:  
    struct omniConfig _conf;
};

// Device class
class Device {
  public:
    Device();
    void setupModules();
    void getModuleStatus(module_t modules[]);
    boolean addModule(Module *);
    void run();
  protected:
    Module * _configuredModules[MAX_MODULES_X_DEVICE];
    byte _configuredModulesSize = 0;
};

#endif


