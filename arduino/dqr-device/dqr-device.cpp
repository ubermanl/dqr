/*
 * Source code for the DqR device library
 * Version: 1.0
 * --- DqR Systems 2017 ---
 */
#include "Arduino.h"
#include "dqr-device.h"

Lux::Lux(int pinRelay, int pinTouch, int pinAcSensor, int acSensorSensitivity) {
  pinMode(pinRelay, OUTPUT);
  pinMode(pinTouch, INPUT);
  pinMode(pinAcSensor, INPUT);
  _pinRelay = pinRelay;
  _pinTouch = pinTouch;
  _pinAcSensor = pinAcSensor;
  _acSensorSensitivity = acSensorSensitivity;
};


Potentia::Potentia(int pin) {
  pinMode(pin, OUTPUT);
  _pin = pin;
};

