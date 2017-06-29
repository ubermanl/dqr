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

/*----------------------------[ Data Structures ]-----------------------------*/
struct sensor_t {
  byte sensorId;
  byte sensorType;
  float avgValue;
};

struct module_t {
  byte moduleId;
  byte moduleType;
  sensor_t sensors[];
  byte state;
};

/*--------------------------------[ Classes ]---------------------------------*/

// class Sensor implements the different type of sensors
class Sensor {
  public:
    void setup(byte);
    byte getId();
    float getAverageValue();
    void senseData();
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
class ACSensor : Sensor {
  public:
    ACSensor();
    void senseData();
    float getACValue();
  protected:
    int _acSensorSensitivity;
};

class PIRSensor : Sensor {
  public:
    PIRSensor();
    void senseData();
    float getAverageValue();
  protected:
    int _timer;
};

class TempSensor : Sensor {
  public:
    TempSensor();
    void senseData();
  protected:
};

class SoundSensor : Sensor {
  public:
    SoundSensor();
    void senseData();
  protected:    
};

class LightSensor : Sensor {
  private:
    LightSensor();
    void setup(byte);
    void senseData();
  protected:
    BH1750 _lightSensor;
};


// Module class and the different classes that it implements (Lux, Potentia, Omni)
class Module {
  public:
    Module();
    void getSensorsData();
    void getState();
    boolean addSensor(Sensor);
    void setupSensor();
    boolean setRelayStatus(boolean);
    boolean getRelayStatus();
  protected:
    byte _state;
    byte _lastIndex;
    Sensor _configuredSensors[MAX_SENSORS_X_MODULE];
    int _pinRelay;      
    boolean _relayStatus;
};

class Lux : public Module {
  public:
    Lux();
    boolean setup(byte, byte);
  protected:
    int _pinTouch;
};
class Potentia : public Module {
  public:
    Potentia();
    boolean setup(byte);
  protected:
};
class Omni : public Module {
  public:
    Omni();
    boolean setup();
  protected:  
};

// Device class
class Device {
  public:
    Device();
    void getModuleStatus();
    boolean addModule(byte);
  protected:
    byte _lastIndex;
    Module _configuredModules[MAX_MODULES_X_DEVICE];
};

// NetworkModule class
class NetworkModule {
  public:
    void getAddress();
    void setAddress();
    void send();
    void receive();
  protected:
    byte _address;
};

#endif


