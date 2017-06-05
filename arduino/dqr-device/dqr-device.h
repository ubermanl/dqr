/*
 * DqR header for file the DqR device library
 * Version: 1.0
 * --- DqR Systems 2017 ---
 */
#ifndef DqR_h
#define DqR_h

#include "Arduino.h"

class Lux {
  public:
    Lux(int pinRelay, int pinTouch, int pinAcSensor, int acSensorSensitivity);
    boolean setRelayStatus(boolean status);
    boolean getRelayStatus();
  private:
    boolean _status;
    int _pinRelay;
    int _pinTouch;
    int _pinAcSensor;
    int _acSensorSensitivity;
};

class Potentia {
  public:
    Potentia(int pin);
    boolean setRelayStatus(boolean status);
    boolean getRelayStatus();
  private:
    boolean _status;
    int _pin;
};

#endif
