/*
 * DqR Lux
 * Version: 1.0
 * --- Dqr Systems 2017 ---
 */

unsigned long time = 0;

// Constants
#define RELAY_OUTPUT 7
#define TOUCH_INPUT  3
#define ACSENSOR_INPUT A0


// Global Variables
int relayState = HIGH;      // relay apagado
int touchCurrent = HIGH;
int touchLastState = LOW;
int acSensorZero = 511;    // Esto es un promedio, pero en el setup se calibra
int mVperAmp = 100;        // 100 mV/A es la sensibilidad del ACS517 de 20A

// Functions
int toggleRelay(int relayState) {
  if (relayState == HIGH) {
    relayState = LOW;
    Serial.println("Relay change: HIGH (Apagado)-->LOW (Encendido)");
  } else {
    relayState = HIGH;
    Serial.println("Relay change: LOW (Apagado-->HIGH (Encendido)");
  }
  digitalWrite(RELAY_OUTPUT, relayState);
  return relayState;
}


int acSensorCalibration() {
  int rVal = 0;
  int sampleDuration = 1000;
  int sampleCount = 0;
  unsigned long rValSum = 0;

  uint32_t startTime = millis();
  while((millis()-startTime) < sampleDuration)
  {
    rVal = analogRead(ACSENSOR_INPUT);
    rValSum += abs(rVal);
    sampleCount++;
  }
  Serial.println("---- Calibracion del sensor AC ----");
  Serial.print("rValSum: ");
  Serial.println(rValSum);
  Serial.print("Cant. Muestras: ");
  Serial.println(sampleCount);

  int rAvg = rValSum / sampleCount;
  Serial.print("Med. promedio: ");
  Serial.print(rAvg);
  Serial.println("--------");
  return rAvg;
}

// Esta funcion recibe como parametros el zero medido y el tiempo de medicion
void acRead(int rZero, int sampleDuration) {
  int rVal = 0;
  int sampleCount = 0;
  unsigned long rSquaredSum = 0;
  //int rZero = 511;                // For illustrative purposes only - should be measured to calibrate sensor.

  uint32_t startTime = millis();  // take samples for 100ms
  while((millis()-startTime) < sampleDuration)
  {
    rVal = analogRead(ACSENSOR_INPUT) - rZero;
    rSquaredSum += rVal * rVal;
    sampleCount++;
  }
  double voltsError = (rZero * 1024) / 5.0;
  double voltRMS = 5.0 * sqrt(rSquaredSum / sampleCount) / 1024.0;
  //Serial.print(rSquaredSum);
  //Serial.print(" rSquaredSum | ");
  //Serial.print(sampleCount);
  //Serial.print(" sampleCount | ");
  Serial.print(sqrt(rSquaredSum / sampleCount));
  Serial.print(" sqrt(rSquaredSum / sampleCount) | ");
  Serial.print(voltRMS);
  Serial.print(" v RMS | ");
  Serial.print(voltsError);
  Serial.print(" voltsError | ");

  // x 1000 to convert volts to millivolts
  // divide by the number of millivolts per amp to determine amps measured
  // the 20A module 100 mv/A (so in this case ampsRMS = 10 * voltRMS
  double ampsRMS = voltRMS * 10.0;
  Serial.print(ampsRMS);
  Serial.println(" A RMS");
}


// Arduino Inicialization
void setup() {
  pinMode(RELAY_OUTPUT, OUTPUT);
  pinMode(TOUCH_INPUT, INPUT);
  pinMode(ACSENSOR_INPUT, INPUT);
  Serial.begin(9600);

  // Apago el enchufe para asegurar lectura sin consumo
  digitalWrite(RELAY_OUTPUT, HIGH);
  //acSensorZero = acSensorCalibration();
  // Lo prendo de nuevo
  //digitalWrite(RELAY_OUTPUT, LOW);
  //Serial.print("Zero del sensor sin carga: ");
  //Serial.println(acSensorZero);
  
}

// Arduino operation
void loop(){
  //Serial.print("Time: ");
  time = millis();
  //prints time since program started
  //Serial.print(time);
  //Serial.print(" | "); 
  touchCurrent = digitalRead(TOUCH_INPUT);

  if (touchCurrent == HIGH) {
    if (touchLastState != touchCurrent) {
      touchLastState = touchCurrent;
      Serial.println("** Touch presionado **");
      relayState = toggleRelay(relayState);
    }  
  } else
      touchLastState = LOW;

   // Leer del sensor se corriente durante 1s, cada 59s
   int minute = time % 1000;
   //Serial.print("Minuto: ");
   //Serial.println(minute);
   
   if (minute == 0) {
     //Serial.print("Time: ");
     //Serial.print(time);
     //Serial.print(" | ");
     //acRead(acSensorZero, 1000);
     //Serial.print("Lectura del sensor: ");
     //Serial.println(analogRead(ACSENSOR_INPUT));
     //minute = 0;
   }
   //Serial.print("Time: ");
   //Serial.print(time);
   //Serial.print("Lectura del sensor: ");
   Serial.println(analogRead(ACSENSOR_INPUT));
   delay(20);

}
