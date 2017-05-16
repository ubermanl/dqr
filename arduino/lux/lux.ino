/*
 * DqR Lux
 * Version: 1.0
 * --- Dqr Systems 2017 ---
 */


// Constants
#define RELAY_OUTPUT 7
#define TOUCH_INPUT  3

// Global Variables
int relayState = HIGH;      // relay apagado
int touchCurrent = LOW;
int touchLastState = LOW;

// Functions
int toggleRelay(int relayState) {
  if (relayState == HIGH) {
    relayState = LOW;
  } else {
    relayState = HIGH;
  }
  digitalWrite(RELAY_OUTPUT, relayState);
  return relayState;
}


// Arduino Inicialization
void setup() {
  pinMode(RELAY_OUTPUT, OUTPUT);
  pinMode(TOUCH_INPUT, INPUT);
  Serial.begin(9600);
}

// Arduino operation
void loop(){
  
  touchCurrent = digitalRead(TOUCH_INPUT);

  if (touchCurrent == HIGH) {
    if (touchLastState != touchCurrent) {
      touchLastState = touchCurrent;
      Serial.println("Touch presionado");
      relayState = toggleRelay(relayState);     
    }  
  } else
      touchLastState = LOW;
}
