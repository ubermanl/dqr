#include "dqr-device.h"

/*** Static variables definitions ***/
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
	
	_timer = 0;
}

/*** Device running in loop() ***/
void Device::run() {
	_devFSM->update();
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
	
	// Send to the master node every second
	if (millis() - _timer >= 5000) {
		_timer = millis();
		LOG2("Current Device State: ",_currentState);

    /* payload I example */
    payload_sensor sensor1, sensor2, sensor3;
    sensor1.sensorId = 5;
    float value1 = 123.98765;
    /*
    unsigned char const * p = reinterpret_cast<unsigned char const *>(&value1);
    for (unsigned char i = 0; i != sizeof(float); ++i) {
      sensor1.value[i] = p[i];
    }
    */
    sensor1.value = value1;
    sensor2.sensorId = 2;
    sensor2.value = 234.567;
    sensor3.sensorId = 2;
    sensor3.value = 9876.1234;
    payload_module module1, module2;
    module1.moduleId = 1;
    module1.state = 2;
    module1.sensors[0] = sensor1;
    module1.sensors[1] = sensor2;
    module2.moduleId = 5;
    module2.state = 3;
    module2.sensors[0] = sensor3;
    payload_I payload;
    payload.deviceId = 2;
    payload.modules[0] = module1;
    payload.modules[1] = module2;
    sendMessage(&payload, 'I', sizeof(payload));
/*    for(int i=0; i<MAX_MODULES_X_DEVICE; i++) {
      LOG2(" ModId", payload.modules[i].moduleId);
      for(int j=0; j<MAX_SENSORS_X_MODULE; j++) {
      LOG2(" SensorId", payload.modules[i].sensors[j].sensorId);
    }
    }*/
	}

  receive();
}


/*** Private Functions ***/

void Device::sendMessage(const void * data, uint8_t msg_type, size_t size) {
  if (!_mesh->write(data, msg_type, size)) {
    LOG("Send Failed!");
    _devFSM->transitionTo(*_sPreconfigured);
  } else {
    LOG2("Send OK: ",_timer);
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
        LOG2("Received packet #", payload.subtype);
        break;
      }
      case INFORM_MESSAGE:
      {
        payload_I payload;
        _network->read(header, &payload, sizeof(payload));
        LOG2("Received packet #", payload.deviceId);
        break;
      }
      case ACTION_MESSAGE:
      {
        payload_A payload;
        _network->read(header, &payload, sizeof(payload));
        LOG2("Received packet #", payload.moduleId);
        break;
      }
      default:
        LOG("Error in received message: Invalid type");
    }
    
  }
}

