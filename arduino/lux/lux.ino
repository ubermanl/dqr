/*
 * DqR Lux
 * Version: 1.0
 * --- Dqr Systems 2017 ---
 */


// Constants
#define LUX_OUTPUT 7
#define TOUCH_INPUT  2
#define CURRENT_INPUT A0
#define LUX_DEFAULT_RELAY HIGH

// Global Variables
int relayState = LUX_DEFAULT_RELAY;      // relay apagado
int touchCurrent = LOW;
int touchLastState = LOW;


// Functions
int toggleRelay(int relayState) {
  if (relayState == HIGH) {
    relayState = LOW;
  } else {
    relayState = HIGH;
  }
  digitalWrite(LUX_OUTPUT, relayState);
  return relayState;
}

void processMessages() {
  if (Serial.available() > 0) {
    Serial.print("Processing messages...");
  	if (Serial.readString() == "R1") {
    	relayState = toggleRelay(relayState);
  	}
    Serial.println(" Complete!");
  }
}


// Arduino Inicialization
void setup() {
  pinMode(LUX_OUTPUT, OUTPUT);
  pinMode(TOUCH_INPUT, INPUT);
  Serial.begin(9600);
  Serial.flush();

  digitalWrite(LUX_OUTPUT, LUX_DEFAULT_RELAY);
}

// Arduino operation
void loop(){

  // Process Messages
  processMessages();
  
  // Gather sensor data
  
  
  // Override Operation
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