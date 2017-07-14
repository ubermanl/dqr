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
Sensor::Sensor(byte id, byte type, byte pin) {
  _id = id;
  _typeId = type;
  _pinSensor = pin;
  _accumulatedValue = 0;
  _currentValue = 0;
  _sampleCount = 0;
}

void Sensor::setup() {
  pinMode(_pinSensor, INPUT);
}

float Sensor::getAverageValue() {
  if (_sampleCount == 0) {
    return 0;
  }
  float avg = _accumulatedValue / _sampleCount;
  _accumulatedValue = 0;
  _sampleCount = 0;
  return avg;
};

// Sound
SoundSensor::SoundSensor(byte id, byte pin) : Sensor(id, SND_TYPE_ID, pin) {};

void SoundSensor::senseData() {
  _currentValue = analogRead(_pinSensor);
  _accumulatedValue += _currentValue;
  _sampleCount += 1;
};

// PIR
PIRSensor::PIRSensor(byte id, byte pin) : Sensor(id, PIR_TYPE_ID, pin) {};

void PIRSensor::senseData() {
  _currentValue = digitalRead(_pinSensor);
  /* TODO: "suavizar" deteccion de movimiento
  if ( _currentValue == 1 )
    _timer = 0;
  else if ( _timer < PIR_TIMEOUT_SECONDS )
    _currentValue = 1;
  */
};

float PIRSensor::getAverageValue() {
  return _currentValue;
};

// Light
LightSensor::LightSensor(byte id, byte pin) : Sensor(id, LUM_TYPE_ID, pin) {};

void LightSensor::setup() {
  _lightSensor.begin(BH1750_CONTINUOUS_HIGH_RES_MODE_2);
};

void LightSensor::senseData() {
  _currentValue = _lightSensor.readLightLevel();
  _accumulatedValue += _currentValue;
  _sampleCount += 1;
};

// AC
ACSensor::ACSensor(byte id, byte pin) : Sensor(id, AC_TYPE_ID, pin) {};

void ACSensor::senseData() {
  _currentValue = getACValue();
  _accumulatedValue += _currentValue;
  _sampleCount += 1;
};

float ACSensor::getACValue() {
  int numberOfPeriods = 20; // We are measuring 20 cicles of a 50Hz function
  uint32_t startTime = millis();
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
Module::Module(byte id, byte type) {
  _id = id;
  _typeId = type;
  _configuredSensorsSize = 0;
  _relayStatus = 0;
};

Lux::Lux(struct luxConfig conf) : Module(conf.ID, LUX_TYPE_ID) {
  _conf = conf;  
}

boolean Lux::setup() {
  if ( _conf.TOUCH_IN != 2 && _conf.TOUCH_IN != 3) {
    return false;
  }
  _pinTouch = _conf.TOUCH_IN;
  _pinRelay = _conf.RELAY_OUT;
  pinMode(_pinTouch, INPUT);
  pinMode(_pinRelay, OUTPUT);  
  _relayStatus = HIGH; // Lux default is off
  digitalWrite(_pinRelay, ! _relayStatus);
  return true;
};

Potentia::Potentia(struct potentiaConfig conf) : Module(conf.ID, POTENTIA_TYPE_ID) {
  _conf = conf;
}

boolean Potentia::setup() {
  _pinRelay = _conf.RELAY_OUT;
  pinMode(_pinRelay, OUTPUT);
  _relayStatus = LOW; // Potentia default is on
  digitalWrite(_pinRelay, ! _relayStatus);  
  return true;
};

Omni::Omni(struct omniConfig conf) : Module(conf.ID, OMNI_TYPE_ID) {
  _conf = conf;
}

boolean Omni::setup() {
  return true;
};

void Module::setRelayStatus(boolean newStatus) {
  if (_relayStatus != newStatus) {
    digitalWrite(_pinRelay, ! newStatus);
    _relayStatus = newStatus;
  };
};

boolean Module::getRelayStatus() {
  return _relayStatus;
};

void Module::toggleRelayStatus() {
  setRelayStatus(!getRelayStatus());
};

void Module::setupSensors() {
  for (int i=0; i < _configuredSensorsSize; i++) {
    _configuredSensors[i]->setup();
  }
};

void Module::getSensorsData(sensor_t sensors[]) {
  for (int i=0; i < _configuredSensorsSize; i++) {
     sensors[i].sensorId = _configuredSensors[i]->getId();
     sensors[i].sensorType = _configuredSensors[i]->getType();
     sensors[i].avgValue = _configuredSensors[i]->getAverageValue();
  }
};

boolean Module::addSensor(Sensor * sen) {
 if(_configuredSensorsSize >= MAX_SENSORS_X_MODULE){
  return false;
 }
 _configuredSensors[_configuredSensorsSize] = sen;
 _configuredSensorsSize++;
 return true;
};

void Module::run() {
  for (int i=0; i < _configuredSensorsSize; i++) {
     _configuredSensors[i]->senseData();
  }
}



/*----------------------------------[ Device ]----------------------------------*/
Device::Device() {};

void Device::getModuleStatus(module_t modules[]) {
  for (int i=0; i < _configuredModulesSize; i++) {
     modules[i].moduleId = _configuredModules[i]->getId();
     modules[i].moduleType = _configuredModules[i]->getType();
     modules[i].state = _configuredModules[i]->getState();
     _configuredModules[i]->getSensorsData(modules[i].sensors);
  }
};

boolean Device::addModule(Module * newModule) {
  if(_configuredModulesSize >= MAX_MODULES_X_DEVICE){
    return false;
  }
  _configuredModules[_configuredModulesSize] = newModule;
  _configuredModulesSize++;
  return true;
};

void Device::setupModules() {  
  for (int i=0; i < _configuredModulesSize; i++) {
    _configuredModules[i]->setup();
    _configuredModules[i]->setupSensors();
    switch (_configuredModules[i]->getType()) {
      case LUX_TYPE_ID:
        LOG2("LUX Module Setup, id: ", _configuredModules[i]->getId());
        break;
      case POTENTIA_TYPE_ID:
        LOG2("POTENTIA Module Setup, id: ", _configuredModules[i]->getId());
        break;
      case OMNI_TYPE_ID:
        LOG2("OMNI Module Setup, id: ", _configuredModules[i]->getId());
        break;
    }
  }
}

void Device::run() {
  for (int i=0; i < _configuredModulesSize; i++) {
     _configuredModules[i]->run();
  }
}


