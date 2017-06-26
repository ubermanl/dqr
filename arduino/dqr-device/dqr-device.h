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


// class Sensor implements the different type of sensors
class Sensor {
  public:
    Sensor();

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
  protected:
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
    void senseData();
  protected:
    BH1750 _lightSensor;
};


// Module class and the different classes that it implements (Lux, Potentia, Omni)
class Module {
  public:
    Module(int);
    void getSensorsData();
    void getState();
    void addSensor(Sensor);
    void setupSensor();
    boolean setRelayStatus(boolean);
    boolean getRelayStatus();
  protected:
    byte _state;
    byte _lastIndex;
    Sensor _configuredSensors[MAX_SENSORS_X_MODULES];
    int _pinRelay;      
    boolean _relayStatus;
};

class Lux : Module {
  public:
    Lux(int, int);
  protected:
    int _pinTouch;
};
class Potentia : Module {
  public:
    Potentia(int);
  protected:
};
class Omni : Module {
  public:
  protected:  
};

// Device class
class Device {
  public:
    Device();
    void getModuleStatus();
    void addModule(Module);
  protected:
    Module _configuredModules[];
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


