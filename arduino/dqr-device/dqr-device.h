/*
 * DqR header for file the DqR device library
 * Version: 1.0
 * --- DqR Systems 2017 ---
 */
#ifndef DqR_h
#define DqR_h

#include "Arduino.h"
#include <BH1750.h>


// class Sensor implements the different type of sensors
class Sensor {
  public:
    Sensor(int pin);
    byte getId();
    float getAverageValue();
    void senseData();
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
    ACSensor(int);
    void senseData();
    float getACValue();
  protected:
    int _acSensorSensitivity;
};

class PIRSensor : public Sensor {
  public:
    PIRSensor(int);
    void senseData();
  protected:
};

class TempSensor : public Sensor {
  public:
    TempSensor();
    void senseData();
  protected:
};

class SoundSensor : public Sensor {
  public:
    SoundSensor(int);
    void senseData();
  protected:    
};

class LightSensor : public Sensor {
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
    Sensor _configuredSensors[];
    int _pinRelay;      
    boolean _relayStatus;
};

class Lux : public Module {
  public:
    Lux(int);
  protected:
    int _pinTouch;
};
class Potentia : public Module {
  public:
    Potentia(int);
  protected:
};
class Omni : public Module {
  public:
  protected:  
};

// Device class
class Device {
  public:
    void getModuleStatus();
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


