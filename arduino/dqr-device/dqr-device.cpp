/*
 * DqR Device implementation of classes
 * Version: 2.0
 * --- DqR Systems 2017 ---
 */

#include "dqr-device.h"
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


/*------------------------------[ Constructors ]------------------------------*/
Module::Module() {
  _lastIndex = -1;
  //_pinRelay = pinRelay;  
};

Lux::Lux(): Module() {
  //_pinTouch = pinTouch;
  pinMode(_pinTouch, INPUT);
  pinMode(_pinRelay, OUTPUT);  
  _relayStatus = HIGH; // Lux default is off
  digitalWrite(_pinRelay, ! _relayStatus);
};

Potentia::Potentia(): Module() {
  pinMode(_pinRelay, OUTPUT);
  _relayStatus = LOW; // Potentia default is on
  digitalWrite(_pinRelay, ! _relayStatus);
}

Omni::Omni(): Module() {  
};

PIRSensor::PIRSensor() {
  pinMode(_pinSensor, INPUT);
};

LightSensor::LightSensor() {
  _lightSensor.begin(BH1750_CONTINUOUS_HIGH_RES_MODE_2);
};

ACSensor::ACSensor() {
  pinMode(_pinSensor, INPUT);
};

SoundSensor::SoundSensor() {
  pinMode(_pinSensor, INPUT);  
}
/*--------------------------[ end of Constructors ]---------------------------*/


/*--------------[ implementation of methods for the Module class ]------------*/
boolean Module::setRelayStatus(boolean newStatus) {
  if (_relayStatus != newStatus) {
    digitalWrite(_pinRelay, ! newStatus);
    _relayStatus = newStatus;
  };
  return _relayStatus;
};

boolean Module::getRelayStatus() {
  return _relayStatus;
};

void Module::getSensorsData() {
};

void Module::getState() { 
};

boolean Module::addSensor(Sensor sen) {
 if(_lastIndex == MAX_SENSORS_X_MODULE){
  return false;
 }
 _lastIndex++;
 _configuredSensors[_lastIndex] = sen;
 return true;
};

void Module::setupSensor() {
};

/*---------------[ implementation of methods for Sensor class ]---------------*/
float Sensor::getAverageValue() {
  float avg = _accumulatedValue / _sampleCount;
  _accumulatedValue = 0;
  _sampleCount = 0;
  return avg;
};

void Sensor::setup(int pin) {
  _pinSensor = pin;
};

/*--------------[ implementation of methods for the Device class ]------------*/
Device::Device() {  
};

void Device::getModuleStatus() {

};

boolean Device::addModule(byte modType) {
  if(_lastIndex == MAX_MODULES_X_DEVICE){
    return false;
  }
  _lastIndex++;
  Lux luxmodule;
  Potentia potmodule;
  Omni omnimodule;
  switch (modType) {
    case LUX_TYPE_ID:
      _configuredModules[_lastIndex] = luxmodule;
      return true;
    case POTENTIA_TYPE_ID:
      _configuredModules[_lastIndex] = potmodule;
      return true;
    case OMNI_TYPE_ID:
      _configuredModules[_lastIndex] = omnimodule;
      return true;
  };
  return false;
};

/*-----[ implementation of senseData for the different types of sensors ]-----*/
// AC
void ACSensor::senseData() {
  _currentValue = getACValue();
  _accumulatedValue += _currentValue;
  _sampleCount += 1;
};

// Sound
void SoundSensor::senseData() {
  _currentValue = analogRead(_pinSensor);
  _accumulatedValue += _currentValue;
  _sampleCount += 1;
};

// PIR
void PIRSensor::senseData() {
  _currentValue = digitalRead(_pinSensor);
  _accumulatedValue += _currentValue;
  _sampleCount += 1;
};

// Light
void LightSensor::senseData() {
  _currentValue = _lightSensor.readLightLevel();
  _accumulatedValue += _currentValue;
  _sampleCount += 1;
};


/*---------------[ helper function for converting steps to mAmp ]---------------*/
float ACSensor::getACValue() {
  int numberOfPeriods = 20; // We are measuring 20 cicles of a 50Hz function
  double startTime = millis();
  int max = 0;
  int min = 1023;
  int rVal = 0;
  while ((millis() - startTime) < 20*numberOfPeriods) {
    rVal = analogRead(_pinSensor);
    if (rVal > max) {
      max = rVal;
    }
    if (rVal < min) {
      min = rVal;
    }
  }
  int steps = (max - min); 
  
  // if steps <= 7, then it's probably noise. If it's not, then we can't measure this type of current anyway
  if (steps <= 7) return 0;
  
  /* The number of steps should be multiplied by 5 and divided by 1024 to convert to volts, then divided by 2 to get
   * just one side of the sin function. Then it should be multiplied by sqrt(2)/2 to get RMS Volts, and multiply by 1000 
   * to convert  to mVs. Finally, divide by sensorSensitivity, which is expressed in mV/A.
   *
   * Instead of doing that, I'm going to multiply first, then divide, so that decimals are not lost in the calculation.
   * This helps calculate on very small currents.
   *
   * Vrms = {[(steps * 5/1024) / 2 ] * sqrt(2)/2 } * 1000/_acSensorSensitivity
   *      = (steps * 5 * 1000 * sqrt(2) ) / (1024 * 2 * 2 * _acSensorSensitivity)
   *      = (steps * 5000 * sqrt(2)) / (4096 * acSensorSensitivity)
   */
  float Vrms = steps*sqrt(2)*5000/4096;
  return Vrms/_acSensorSensitivity;
};


