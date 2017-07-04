/*
 * DqR Device implementation of classes
 * Version: 2.0
 * --- DqR Systems 2017 ---
 */

#include "dqr-device.h"

/*
 * Definition of constructors and methods of the different classes.
 * Note that Device uses Module, and Module uses Sensor, so declaring bottom-up
 * 
 */

/*----------------------------------[ Sensor ]----------------------------------*/
void Sensor::setup(byte pinSensor) {
  _pinSensor = pinSensor;
  pinMode(_pinSensor, INPUT);
};

float Sensor::getAverageValue() {
  float avg = _accumulatedValue / _sampleCount;
  _accumulatedValue = 0;
  _sampleCount = 0;
  return avg;
};


// Sound
SoundSensor::SoundSensor() {};
void SoundSensor::senseData() {
  _currentValue = analogRead(_pinSensor);
  _accumulatedValue += _currentValue;
  _sampleCount += 1;
};

// PIR
PIRSensor::PIRSensor() {};

void PIRSensor::senseData() {
  _currentValue = digitalRead(_pinSensor);
  if ( _currentValue == 1 )
    _timer = 0;
  else if ( _timer < PIR_TIMEOUT_SECONDS )
    _currentValue = 1;
  };

float PIRSensor::getAverageValue() {
  return _currentValue;
};

// Light
LightSensor::LightSensor() {};
void LightSensor::setup(byte dummy) {
  _lightSensor.begin(BH1750_CONTINUOUS_HIGH_RES_MODE_2);
};

void LightSensor::senseData() {
  _currentValue = _lightSensor.readLightLevel();
  _accumulatedValue += _currentValue;
  _sampleCount += 1;
};

// AC
ACSensor::ACSensor() {};

void ACSensor::senseData() {
  _currentValue = getACValue();
  _accumulatedValue += _currentValue;
  _sampleCount += 1;
};

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



/*----------------------------------[ Module ]----------------------------------*/
Module::Module() {
  _lastIndex = -1;
};

Lux::Lux(): Module() {};
Potentia::Potentia(): Module() {};
Omni::Omni(): Module() {};

boolean Lux::setup(byte pinRelay, byte pinTouch) {
  if ( pinTouch == 2 || pinTouch == 3)
    return false;

  _pinTouch = pinTouch;
  _pinRelay = pinRelay;
  pinMode(_pinTouch, INPUT);
  pinMode(_pinRelay, OUTPUT);  
  _relayStatus = HIGH; // Lux default is off
  digitalWrite(_pinRelay, ! _relayStatus);

  // Prefixed list of sensors to add to a Lux device
  //PIRSensor newSensor;
  //addSensor(newSensor);
  //ACSensor newSensor;
  //addSensor(newSensor);
  
  return true;
};

boolean Potentia::setup(byte pinRelay) {
  _pinRelay = pinRelay;
  pinMode(_pinRelay, OUTPUT);
  _relayStatus = LOW; // Potentia default is on
  digitalWrite(_pinRelay, ! _relayStatus);  
};

boolean Omni::setup() {};

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

void Module::setupSensor() {};
void Module::getSensorsData() {};
void Module::getState() {};

boolean Module::addSensor(Sensor sen) {
 if(_lastIndex == MAX_SENSORS_X_MODULE){
  return false;
 }
 _lastIndex++;
 _configuredSensors[_lastIndex] = sen;
 return true;
};



/*----------------------------------[ Device ]----------------------------------*/
Device::Device() {};

void Device::getModuleStatus() {};

boolean Device::addModule(Module newModule) {
  if(_lastIndex == MAX_MODULES_X_DEVICE){
    return false;
  }
  _lastIndex++;
  _configuredModules[_lastIndex] = newModule;
  return true;
};


