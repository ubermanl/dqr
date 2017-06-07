/*
 * DqR header for file the DqR device library
 * Version: 1.0
 * --- DqR Systems 2017 ---
 */
#ifndef DqR_h
#define DqR_h

#include "Arduino.h"
#include <BH1750.h>

// Generic class RelayDevice. Lux and Potentia classes inherite from this
class RelayDevice {
  public:
    RelayDevice(int, int, int);
    boolean setRelayStatus(boolean);
    boolean getRelayStatus();
    double getAcValue();
  protected:
    int _pinRelay;
    int _pinAcSensor;
    boolean _relayStatus;
    int _acSensorSensitivity;  
    int getCurrentSteps();
};

RelayDevice::RelayDevice(int pinRelay, int pinAcSensor, int acSensorSensitivity) {
  _pinRelay = pinRelay;
  _pinAcSensor = pinAcSensor;
  _acSensorSensitivity = acSensorSensitivity;
};

boolean RelayDevice::setRelayStatus(boolean newStatus) {
  if (_relayStatus != newStatus) {
    digitalWrite(_pinRelay, newStatus);
    _relayStatus = newStatus;
  }
  return _relayStatus;
}

boolean RelayDevice::getRelayStatus() {
  return _relayStatus;
}

int RelayDevice::getCurrentSteps() {
  int numberOfPeriods = 20; // We are measuring 20 cicles of a 50Hz function
  double startTime = millis();
  int max = 0;
  int min = 1023;
  int rVal = 0;
  while ((millis() - startTime) < 20*numberOfPeriods) {
    rVal = analogRead(_pinAcSensor);
    if (rVal > max) {
      max = rVal;
    }
    if (rVal < min) {
      min = rVal;
    }
  }
  return (max - min);
}

double RelayDevice::getAcValue() {
  int steps = getCurrentSteps();
  
  // if steps <= 7, then it's probably noise. If it's not, then we can't measure this type of current anyway
  if (steps <= 7) return 0;
  
  // The number of steps is multiplied by 5 and divided by 1024 to convert to volts, then divided by 2 to get
  // just one side of the sin function.
  double Vrms = ((steps * 5/1024) / 2);
  
  // The number of volts that we got above is multiplied by sqrt(2)/2 to get RMS
  Vrms = Vrms * sqrt(2)/2;

  // Finally, the actual AMPs result depends on the sensor sensitivity, which is in mV/A, so multiply by 1000
  // to convert to milivolts and divide by sensitivity.
  Vrms = Vrms * 1000/_acSensorSensitivity;

  return Vrms;
}


// Class for Lux devices
class Lux : public RelayDevice {
  public:
    Lux(int, int, int, int, int, int);
    void setup();
    int getSoundValue();
    boolean getTouchStatus();
    int getLumValue();
    boolean getPirStatus();
  private:
    int _pinTouch;
    boolean _touchLast = false;
    int _pinSound;
    int _pinPir;
    BH1750 _lightSensor;
};

Lux::Lux(int pinRelay, int pinAcSensor, int acSensorSensitivity, int pinTouch, int pinSound, int pinPir): RelayDevice(pinRelay, pinAcSensor, acSensorSensitivity) {
  _relayStatus = LOW; // LUX default is off
  _pinTouch = pinTouch;
  _pinSound = pinSound;
  _pinPir = pinPir;  
}

void Lux::setup() {
  pinMode(_pinRelay, OUTPUT);
  pinMode(_pinAcSensor, INPUT);
  pinMode(_pinTouch, INPUT);
  pinMode(_pinSound, INPUT);
  pinMode(_pinPir, INPUT);
  digitalWrite(_pinRelay, _relayStatus);
  digitalWrite(_pinPir, LOW); //Necesario? Probar comentado
  _lightSensor.begin(BH1750_CONTINUOUS_HIGH_RES_MODE_2);
};

boolean Lux::getTouchStatus() {
  boolean touchCurrent = digitalRead(_pinTouch);
  if (touchCurrent != _touchLast) {
    //Serial.println("*** touch pressed or released ***");
    _touchLast = touchCurrent;
    return ! _touchLast;
  }
  return LOW;
}

int Lux::getSoundValue() {
  // falta suavizar
  return analogRead(_pinSound);
}

boolean Lux::getPirStatus() {
  return digitalRead(_pinPir);
}

int Lux::getLumValue() {
  // falta suavizar
  return _lightSensor.readLightLevel();
}


// Class for Potentia devices
class Pot : public RelayDevice {
  public:
    Pot(int pinRelay, int pinAcSensor, int acSensorSensitivity);
    void setup();
};

Pot::Pot(int pinRelay, int pinAcSensor, int acSensorSensitivity): RelayDevice(pinRelay, pinAcSensor, acSensorSensitivity) {
};

void Pot::setup() {
  pinMode(_pinRelay, OUTPUT);
  pinMode(_pinAcSensor, INPUT);
}

#endif
