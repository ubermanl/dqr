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
Sensor::Sensor(byte type, byte pin) {
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
  /** Uncomment below for debugging purposes **/
  /*
  LOG2(" .. Sensor Sample Count: ",_sampleCount);
  LOG2(" .. Accumulated Value: ",_accumulatedValue);
  */
  if (_sampleCount == 0) {
    return 0;
  }
  float avg = _accumulatedValue / _sampleCount;
  _accumulatedValue = 0;
  _sampleCount = 0;
  return avg;
};

// Sound
SoundSensor::SoundSensor(byte pin) : Sensor(SND_TYPE_ID, pin) {};

void SoundSensor::senseData() {
  _currentValue = analogRead(_pinSensor);
  if (_accumulatedValue + _currentValue > MAX_ACCUMULATED_VALUE) {
    _accumulatedValue = getAverageValue();
  }
  _accumulatedValue += _currentValue;
  _sampleCount += 1;
};

// PIR
PIRSensor::PIRSensor(byte pin) : Sensor(PIR_TYPE_ID, pin) {};

void PIRSensor::senseData() {
  _currentValue = digitalRead(_pinSensor);

  if ( _currentValue == 1 ) {
    if ( (millis() - _timer) / 1000 > PIR_TIMEOUT_SECONDS ) {
      /* Send movement detection */
      _notifyCurrentValue = true;
    }
    _timer = millis();
  } else {
    if ( (millis() - _timer) / 1000 < PIR_TIMEOUT_SECONDS ) {
      _currentValue = 1;
    }
  }      
};

float PIRSensor::getAverageValue() {
  return _currentValue;
};

// Light
LightSensor::LightSensor(byte pin) : Sensor(LUM_TYPE_ID, pin) {};

void LightSensor::setup() {
  _lightSensor.begin(BH1750_CONTINUOUS_HIGH_RES_MODE_2);
};

void LightSensor::senseData() {
  _currentValue = _lightSensor.readLightLevel();
  if (_accumulatedValue + _currentValue > MAX_ACCUMULATED_VALUE) {
    _accumulatedValue = getAverageValue();
  }
  _accumulatedValue += _currentValue;
  _sampleCount += 1;
};

// AC
ACSensor::ACSensor(byte pin, int sensitivity) : Sensor(AC_TYPE_ID, pin) {
  _acSensorSensitivity = sensitivity;
};

void ACSensor::senseData() {
  _currentValue = getACValue();
  if (_accumulatedValue + _currentValue > MAX_ACCUMULATED_VALUE) {
    _accumulatedValue = getAverageValue();
  }
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
Module::Module(byte type) {
  _typeId = type;
  _configuredSensorsSize = 0;
  _relayStatus = 0;
};

void Module::setId(byte modNumber) {
  _id = DEVICE_NODE_ID * pow(10, (int)log10(modNumber)+1) + modNumber;
}

Lux::Lux(struct luxConfig conf) : Module(LUX_TYPE_ID) {
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
  _relayStatus = LUX_DEFAULT_RELAY;
  digitalWrite(_pinRelay, ! _relayStatus);
  return true;
};

void Lux::touchEvent() {
  switch (_state) {
    case MODULE_INACTIVE:
      _state = MODULE_ACTIVE_OVR;
      setRelayStatus(LUX_RELAY_ON);
      break;
    case MODULE_ACTIVE:
      _state = MODULE_INACTIVE_OVR;
      setRelayStatus(LUX_RELAY_OFF);
      break;
    case MODULE_INACTIVE_OVR:
      _state = MODULE_ACTIVE;
      setRelayStatus(LUX_RELAY_ON);
      break;
    case MODULE_ACTIVE_OVR:
      _state = MODULE_INACTIVE;
      setRelayStatus(LUX_RELAY_OFF);
      break;
  }
}

void Lux::setDesiredState(boolean desiredState) {
  if (desiredState) {
    switch (_state) {
      case MODULE_INACTIVE:
        _state = MODULE_ACTIVE;
        setRelayStatus(LUX_RELAY_ON);
        break;
      case MODULE_ACTIVE_OVR:
        _state = MODULE_ACTIVE;
        break;
    }
  } else {
    switch (_state) {
      case MODULE_INACTIVE_OVR:
        _state = MODULE_INACTIVE;
        break;
      case MODULE_ACTIVE:
        _state = MODULE_INACTIVE;
        setRelayStatus(LUX_RELAY_OFF);
        break;
    }
  }
}


Potentia::Potentia(struct potentiaConfig conf) : Module(POTENTIA_TYPE_ID) {
  _conf = conf;
}

boolean Potentia::setup() {
  _pinRelay = _conf.RELAY_OUT;
  pinMode(_pinRelay, OUTPUT);
  _relayStatus = POTENTIA_DEFAULT_RELAY;
  digitalWrite(_pinRelay, ! _relayStatus);  
  return true;
};

void Potentia::setDesiredState(boolean desiredState) {
  if (desiredState) {
    _state = MODULE_ACTIVE;
    setRelayStatus(POTENTIA_RELAY_ON);
  } else {
    _state = MODULE_INACTIVE;
    setRelayStatus(POTENTIA_RELAY_OFF);
  }
}

Omni::Omni(struct omniConfig conf) : Module(OMNI_TYPE_ID) {
  _conf = conf;
}

boolean Omni::setup() {
  return true;
};

void Omni::setDesiredState(boolean desiredState) {
  if (desiredState) {
    _state = MODULE_ACTIVE;
  } else {
    _state = MODULE_INACTIVE;
  }
}

void Module::setRelayStatus(boolean newStatus) {
  if (_relayStatus != newStatus) {
    digitalWrite(_pinRelay, ! newStatus);
    _relayStatus = newStatus;
  };
};

boolean Module::getRelayStatus() {
  return _relayStatus;
};

/*
void Module::toggleRelayStatus() {
  setRelayStatus(!getRelayStatus());
};
*/

void Module::setupSensors() {
  for (int i=0; i < _configuredSensorsSize; i++) {
    _configuredSensors[i]->setup();
  }
};

void Module::getSensorsData(payload_sensor sensors[]) {
  for (int i=0; i < _configuredSensorsSize; i++) {
     sensors[i].sensorType = _configuredSensors[i]->getType();
     sensors[i].value = _configuredSensors[i]->getAverageValue();
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
    if (_configuredSensors[i]->isUrgentNotification()) {
      payload_I payload;
      payload.deviceId = DEVICE_NODE_ID;
      payload.modules[0].moduleId = _id;
      payload.modules[0].state = _state;
      payload.modules[0].sensors[0].sensorType = _configuredSensors[i]->getType();
      payload.modules[0].sensors[0].value = _configuredSensors[i]->getAverageValue();
      Device::sendMessage(&payload, 'I', sizeof(payload));
      _configuredSensors[i]->resetUrgentNotification();
    }
  }
}



/*----------------------------------[ Device ]----------------------------------*/

/*** Static variables definitions ***/
Module * Device::_configuredModules[MAX_MODULES_X_DEVICE];
byte Device::_configuredModulesSize;
State * Device::_sPreconfigured;
State * Device::_sDiscovery;
State * Device::_sAwaitingConnection;
State * Device::_sUnmanaged;
State * Device::_sOperational;
FSM * Device::_devFSM;
byte Device::_currentState;
uint32_t Device::_timer;
RF24Network * Device::_network;
RF24Mesh * Device::_mesh;

/*** Setup device FSM ***/
void Device::setFSM(FSM &fsm, State &pc, State &di, State &aw, State &un, State &op) {
  _sPreconfigured = &pc;
  _sDiscovery = &di;
  _sAwaitingConnection = &aw;
  _sUnmanaged = &un;
  _sOperational = &op;
  _devFSM = &fsm;
}

/*** Setup device Mesh connection ***/
void Device::setNetwork(RF24Network &network, RF24Mesh &mesh) {
  _network = &network;
  _mesh = &mesh;
}

/*** Overall device Setup ***/
void Device::setup() {
  /**** Mesh setup and initialization ****/
  _mesh->setNodeID(DEVICE_NODE_ID);
  LOG(F("Connecting to the mesh..."));
  _mesh->begin();

  _configuredModulesSize = 0;
  _timer = 0;
}

void Device::getModuleStatus(payload_module modules[]) {
  for (int i=0; i < _configuredModulesSize; i++) {
     modules[i].moduleId = _configuredModules[i]->getId();
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
  newModule->setId(_configuredModulesSize);
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

/*** Device methods for different operating States ***/
void Device::runPreconfigured() {
  _currentState = DEVICE_PRECONFIGURED;
  LOG2("Current Device State: ",_currentState);
  
  if (_mesh->checkConnection()) {
    _devFSM->transitionTo(*_sOperational);
  } else {
    _devFSM->transitionTo(*_sDiscovery);
  }
}

void Device::runDiscovery() {
  _currentState = DEVICE_DISCOVERY;
  LOG2("Current Device State: ",_currentState);
  
  _mesh->renewAddress();
  _devFSM->transitionTo(*_sAwaitingConnection);
}

void Device::runAwaitingConnection() {
  _currentState = DEVICE_AWAITINGCONNECTION;
   LOG2("Current Device State: ",_currentState);
  
  if (_mesh->checkConnection()) {
    _devFSM->transitionTo(*_sOperational);
  } else {
    _timer = millis();
    _devFSM->transitionTo(*_sUnmanaged);
  }
}

void Device::runUnmanaged() {
  _currentState = DEVICE_UNMANAGED;
  if (millis() - _timer >= 15000) {
    _timer = millis();
    LOG2("Current Device State: ",_currentState);
    _devFSM->transitionTo(*_sPreconfigured);
  }
}

void Device::runOperational() {
  _currentState = DEVICE_OPERATIONAL;
  
  _mesh->update();
  
  // Send to the master node Information Message
  if ((millis() - _timer) / 1000 >= SEND_TO_RATIO_PERIOD ) {
    _timer = millis();
    LOG2("Current Device State: ",_currentState);
    
    payload_I payload;
    payload.deviceId = DEVICE_NODE_ID;
    getModuleStatus(payload.modules);
    
    sendMessage(&payload, INFORM_MESSAGE, sizeof(payload));
  }
  

  receive();
}

/*** Device running in loop() ***/
void Device::run() {
  _devFSM->update();
  for (int i=0; i < _configuredModulesSize; i++) {
     _configuredModules[i]->run();
  }
}

/*** Private Functions ***/

void Device::sendMessage(const void * data, uint8_t msg_type, size_t size) {
  int count = 0;
  bool sendStatus = false;
  while (count < MAX_MESH_WRITE_RETRIES && !sendStatus) {
    sendStatus = _mesh->write(data, msg_type, size);
    count++;
  }
  if (sendStatus) {
    LOG2("Send OK: ",_timer);
  } else {
    LOG("Send Failed!");
    _devFSM->transitionTo(*_sPreconfigured);
  }
}

void Device::receive() {
  while (_network->available()) {
    RF24NetworkHeader header;
    _network->peek(header);
    switch (header.type) {
      case REQUEST_MESSAGE:
      {
        payload_S payload;
        _network->read(header, &payload, sizeof(payload));
        LOG2("Received packet type S, subtype #", payload.subtype);

        // Sending response
        payload_I response;
        response.deviceId = DEVICE_NODE_ID;
        getModuleStatus(response.modules);
        sendMessage(&response, INFORM_MESSAGE, sizeof(response));
        LOG(" - Sent Inform packet");
        
        break;
      }
      case ACTION_MESSAGE:
      {
        payload_A payload;
        _network->read(header, &payload, sizeof(payload));
        LOG2("Received packet type A for module #", payload.moduleId);

        // Applying action to module
        int i = 0;
        while ( i < _configuredModulesSize) {
          if (_configuredModules[i]->getId() == payload.moduleId && (_configuredModules[i]->getType() == LUX_TYPE_ID || _configuredModules[i]->getType() == POTENTIA_TYPE_ID) ) {
            _configuredModules[i]->setDesiredState(payload.desiredState);
            i = _configuredModulesSize;
            LOG(" - Module desired state applied");
          }
          i++;
        }
        
        break;
      }
      default:
        LOG("Error in received message: Invalid type");
    }
    
  }
}


