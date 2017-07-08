#include "dqr-device.h"

/*** Static variables definitions ***/
State* Device::_sPreconfigured;
State* Device::_sDiscovery;
State* Device::_sAwaitingConnection;
State* Device::_sUnmanaged;
State* Device::_sOperational;
FSM* Device::_devFSM;
byte Device::_currentState;
uint32_t Device::_timer;
RF24Mesh* Device::_network;


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
void Device::setMesh(RF24Mesh &mesh) {
  _network = &mesh;
}

/*** Overall device Setup ***/
void Device::setup() {
	/**** Mesh setup and initialization ****/
	_network->setNodeID(DEVICE_NODE_ID);
  LOG(F("Connecting to the mesh..."));
	_network->begin();
	
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
  
	if (_network->checkConnection()) {
		_devFSM->transitionTo(*_sOperational);
	} else {
		_devFSM->transitionTo(*_sDiscovery);
	}
}

void Device::runDiscovery() {
	_currentState = DEVICE_DISCOVERY;
	LOG2("Current Device State: ",_currentState);
	
	_network->renewAddress();
	_devFSM->transitionTo(*_sAwaitingConnection);
}

void Device::runAwaitingConnection() {
	_currentState = DEVICE_AWAITINGCONNECTION;
	 LOG2("Current Device State: ",_currentState);
  
	if (_network->checkConnection()) {
    _devFSM->transitionTo(*_sOperational);
	} else {
    _timer = millis();
		_devFSM->transitionTo(*_sUnmanaged);
	}
}

void Device::runUnmanaged() {
	_currentState = DEVICE_UNMANAGED;
  LOG2("Current Device State: ",_currentState);
	if (millis() - _timer >= 15000) {
		_timer = millis();
		_devFSM->transitionTo(*_sPreconfigured);
	}
}

void Device::runOperational() {
	_currentState = DEVICE_OPERATIONAL;
		
	_network->update();
	
	// Send to the master node every second
	if (millis() - _timer >= 5000) {
		_timer = millis();
		LOG2("Current Device State: ",_currentState);

		// Send an 'M' type message containing the current millis()
		if (!_network->write(&_timer, 'M', sizeof(_timer))) {
			  LOG("Send Failed!");
			_devFSM->transitionTo(*_sPreconfigured);
		} else {
		  LOG2("Send OK: ",_timer);
		 }
	}
	
}
