EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:arduino
LIBS:Componentes DqR
LIBS:Circuito arduino-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L arduino_nano U1
U 1 1 59A875C3
P 4700 2350
F 0 "U1" H 4800 2600 70  0000 C CNN
F 1 "arduino_nano" H 4950 2450 70  0000 C CNN
F 2 "Modules:Arduino_Nano" H 5050 2600 60  0000 C CNN
F 3 "" H 3350 2350 60  0001 C CNN
	1    4700 2350
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X06 J2
U 1 1 59A8AC46
P 5050 4500
F 0 "J2" H 5050 4850 50  0000 C CNN
F 1 "CONN_01X06" V 5150 4500 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x06_Pitch2.54mm" H 5050 4500 50  0001 C CNN
F 3 "" H 5050 4500 50  0001 C CNN
	1    5050 4500
	0    -1   -1   0   
$EndComp
NoConn ~ 4750 2500
NoConn ~ 4750 2600
NoConn ~ 4750 2700
NoConn ~ 4750 2800
NoConn ~ 4750 2900
NoConn ~ 4750 3200
NoConn ~ 4750 3300
NoConn ~ 4750 3400
NoConn ~ 4750 3500
NoConn ~ 4750 3700
NoConn ~ 4750 3900
NoConn ~ 5350 3900
NoConn ~ 5350 3800
NoConn ~ 5350 3700
NoConn ~ 5350 3400
NoConn ~ 5350 3200
NoConn ~ 5350 3100
NoConn ~ 5350 3000
NoConn ~ 5350 2900
NoConn ~ 5350 2800
NoConn ~ 5350 2700
NoConn ~ 5350 2600
NoConn ~ 5350 2500
$Comp
L CONN_02X08 J1
U 1 1 59A8ABB7
P 2950 4200
F 0 "J1" H 2950 4650 50  0000 C CNN
F 1 "CONN_02X08" V 2950 4200 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_2x08_Pitch2.54mm" H 2950 3000 50  0001 C CNN
F 3 "" H 2950 3000 50  0001 C CNN
	1    2950 4200
	0    1    1    0   
$EndComp
Wire Wire Line
	4800 4700 3300 4700
Wire Wire Line
	3300 4700 3300 4450
Wire Wire Line
	4750 3600 4050 3600
Wire Wire Line
	4050 3600 4050 4700
Connection ~ 4050 4700
Wire Wire Line
	4900 4700 4900 4800
Wire Wire Line
	4900 4800 3500 4800
Wire Wire Line
	3500 4800 3500 3950
Wire Wire Line
	3500 3950 2600 3950
Connection ~ 3800 4800
Wire Wire Line
	5000 4700 5000 5050
Wire Wire Line
	5000 5050 2150 5050
Wire Wire Line
	2150 5050 2150 3000
Wire Wire Line
	2150 3000 4750 3000
Wire Wire Line
	5100 4700 5100 4900
Wire Wire Line
	5100 4900 2250 4900
Wire Wire Line
	2250 4900 2250 3100
Wire Wire Line
	2250 3100 4750 3100
Wire Wire Line
	5200 4700 5200 5050
Wire Wire Line
	5200 5050 6300 5050
Wire Wire Line
	6300 5050 6300 3300
Wire Wire Line
	6300 3300 5350 3300
Wire Wire Line
	5300 4700 6200 4700
Wire Wire Line
	6200 4700 6200 3500
Wire Wire Line
	6200 3500 5350 3500
Connection ~ 3300 3950
Connection ~ 3200 3950
Connection ~ 3100 3950
Connection ~ 3000 3950
Connection ~ 2900 3950
Connection ~ 2800 3950
Connection ~ 2700 3950
Connection ~ 3300 4450
Wire Wire Line
	3300 4450 2600 4450
Connection ~ 3200 4450
Connection ~ 3100 4450
Connection ~ 3000 4450
Connection ~ 2900 4450
Connection ~ 2800 4450
Connection ~ 2700 4450
NoConn ~ 4750 3800
Wire Wire Line
	3800 4800 3800 5250
Wire Wire Line
	3800 5250 6500 5250
Wire Wire Line
	6500 5250 6500 3600
Wire Wire Line
	6500 3600 5350 3600
$EndSCHEMATC
