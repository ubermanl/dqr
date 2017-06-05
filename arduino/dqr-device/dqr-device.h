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
    Lux(int pin);
    boolean setRelayStatus(boolean new);
    boolean getRelayStatus();
  private:
    boolean status;
    int pin;
}

class Potentia {
  public:
    Potentia(int pin);
    boolean setRelayStatus(boolean new);
    boolean getRelayStatus();
  private:
    boolean status;
    int pin;
}


#endif
