/*
 * DqR Lux
 * Version: 1.0
 * --- Dqr Systems 2017 ---
 */

#include <FiniteStateMachine.h>

// Constants
#define LUX_OUTPUT 13
#define TOUCH_INPUT  3
#define CURRENT_INPUT A0
#define LUX_DEFAULT_RELAY LOW

// Global Variables
int relayState = LUX_DEFAULT_RELAY;      // relay apagado
//int touchCurrent = LOW;
//int touchLastState = LOW;

// Function primitives
void LuxOperational();

// FSM Variables
State LuxInactive = State(LuxOperational);
State LuxActive = State(LuxOperational);
State LuxInactiveOvr = State(LuxOperational);
State LuxActiveOvr = State(LuxOperational);
FSM luxFSM = FiniteStateMachine(LuxInactive);
char estado;


// Arduino Inicialization
void setup() {
  pinMode(LUX_OUTPUT, OUTPUT);
  pinMode(TOUCH_INPUT, INPUT);
  Serial.setTimeout(250);
  Serial.begin(9600);
  Serial.flush();

  digitalWrite(LUX_OUTPUT, LUX_DEFAULT_RELAY);
  
  //Timer1.initialize(100000);
  //Timer1.attachInterrupt(senseTouch);
  
  // Override Operation
  attachInterrupt(digitalPinToInterrupt(TOUCH_INPUT), senseTouch, RISING);
}

// Arduino operation
void loop(){
  luxFSM.update();
}

// Functions
int toggleRelay() {
  if (relayState == HIGH) {
    relayState = LOW;
  } else {
    relayState = HIGH;
  }
  digitalWrite(LUX_OUTPUT, relayState);
}
void lightOn() {
  digitalWrite(LUX_OUTPUT, HIGH);
}
void lightOff() {
  digitalWrite(LUX_OUTPUT, LOW);
}

void processMessages() {
  if (Serial.available() > 0) {
    Serial.print("Processing messages...");
    String msg = Serial.readString();
  	if ( msg == "ON") {
      if (luxFSM.isInState(LuxInactive)) {
    		lightOn();
        	luxFSM.transitionTo(LuxActive);
      } else if (luxFSM.isInState(LuxActiveOvr)) {
        	luxFSM.transitionTo(LuxActive);
      }
    } else if (msg == "OFF") {
      if (luxFSM.isInState(LuxActive)) {
    		lightOff();
        	luxFSM.transitionTo(LuxInactive);
      } else if (luxFSM.isInState(LuxInactiveOvr)) {
        	luxFSM.transitionTo(LuxInactive);
      }
  	}
    Serial.println(" Complete!");
  }
}

void senseTouch() {
  Serial.println("Touch presionado");
  if (luxFSM.isInState(LuxInactive)) {
   	lightOn();
  	luxFSM.transitionTo(LuxActiveOvr);
  } else if (luxFSM.isInState(LuxActive)) {
    lightOff();
	luxFSM.transitionTo(LuxInactiveOvr);
  } else if (luxFSM.isInState(LuxActiveOvr)) {
    lightOff();
    luxFSM.transitionTo(LuxInactive);
  } else if (luxFSM.isInState(LuxInactiveOvr)) {
    lightOn();
    luxFSM.transitionTo(LuxActive);
  }
  //toggleRelay();
}

void LuxOperational() {
  // Process Messages
  processMessages();
  delay(2000);
  if (luxFSM.isInState(LuxInactive)) {
   	estado = 'I';
  } else if (luxFSM.isInState(LuxActive)) {
    estado = 'A';
  } else if (luxFSM.isInState(LuxActiveOvr)) {
    estado = 'T';
  } else if (luxFSM.isInState(LuxInactiveOvr)) {
    estado = 'F';
  }
  Serial.println(estado);
  
  // Gather sensor data
    
  // Send Message
  
}
