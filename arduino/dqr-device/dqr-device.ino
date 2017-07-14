/*
   DqR Device
   Version: 2.0
   --- DqR Systems 2017 ---
*/


// Definition of classes
#include "dqr-device.h"

uint32_t timer = 0;
module_t modules[MAX_MODULES_X_DEVICE];

/*
   Device Initialization: This sample configuration has 1x Lux and 1x Potentia module
*/
Device dqrDevice;
Lux luxModule(luxConfig1);
ACSensor luxACSensor(100, luxConfig1.AC_SENSOR_IN);
PIRSensor pirSensor(101, luxConfig1.PIR_SENS_IN);
SoundSensor soundSensor(102, luxConfig1.SND_SENS_IN);
LightSensor lightSensor(103, luxConfig1.LUM_SENS_SDA);

Potentia potentiaModule(potentiaConfig1);
ACSensor potentiaACSensor(104, potentiaConfig1.AC_SENSOR_IN);


/*** Helper Functions ***/
void toggleRelayStatus() {
  Serial.println("Button pressed");
  luxModule.toggleRelayStatus();
}

void setup() {
  Serial.begin(9600);

  // Sensors Config
  luxModule.addSensor(& luxACSensor);
  luxModule.addSensor(& pirSensor);
  luxModule.addSensor(& soundSensor);
  luxModule.addSensor(& lightSensor);
  potentiaModule.addSensor(& potentiaACSensor);

  // Modules Config
  dqrDevice.addModule(& luxModule);
  dqrDevice.addModule(& potentiaModule);
  dqrDevice.setupModules();

  /**** CONFIG: Interruptions for Lux Modules ****/
  attachInterrupt(digitalPinToInterrupt(luxConfig1.TOUCH_IN), toggleRelayStatus, RISING);

}

void loop() {

  dqrDevice.run();
  
  if (millis() - timer > 5000) {
    timer = millis();
  
    dqrDevice.getModuleStatus(modules);

    int i=0;
    while (i < MAX_MODULES_X_DEVICE && modules[i].moduleId != 0) {
      LOG2("   . Module Id: ", modules[i].moduleId);
      LOG2("   . Module State: ", modules[i].state);
  
      int j = 0;
      while (j < MAX_SENSORS_X_MODULE && modules[i].sensors[j].sensorId != 0) {
        LOG2("     . Sensor Id: ", modules[i].sensors[j].sensorId);
        LOG2("     . Sensor Value: ", modules[i].sensors[j].avgValue);
        j++;
      }
      i++;
    }
    LOG("------------------------ LOOP 5 segs ---------------------------");
 }
}

