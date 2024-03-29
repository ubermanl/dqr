EESchema Schematic File Version 2
LIBS:Circuito de potencia genérico-rescue
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
LIBS:Componentes DqR
LIBS:Circuito de potencia genérico-cache
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
L ACS712-20A ACS712-20A2
U 1 1 5986365D
P 5200 3300
F 0 "ACS712-20A2" V 5200 3300 60  0001 R TNN
F 1 "ACS712-20A" H 5200 3300 60  0001 R TNN
F 2 "Huellas de Componentes DqR:ACS712" H 5200 3300 60  0001 C CNN
F 3 "" H 5200 3300 60  0001 C CNN
	1    5200 3300
	1    0    0    -1  
$EndComp
Text Label 5900 3000 0    60   ~ 0
ACS_Relay_2
Text Label 5900 2450 0    60   ~ 0
ACS_Relay_1
$Comp
L Screw_Terminal_1x04 J1
U 1 1 59863F3A
P 5900 850
F 0 "J1" H 5900 1300 50  0000 C TNN
F 1 "Screw_Terminal_1x04" V 5750 850 50  0000 C TNN
F 2 "Connectors:bornier4" H 5900 425 50  0001 C CNN
F 3 "" H 5875 1050 50  0001 C CNN
	1    5900 850 
	0    -1   1    0   
$EndComp
$Comp
L CONN_01X06 J2
U 1 1 5987931C
P 4150 4300
F 0 "J2" H 4150 4650 50  0000 C CNN
F 1 "CONN_01X06" V 4250 4300 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x06_Pitch1.27mm" H 4150 4300 50  0001 C CNN
F 3 "" H 4150 4300 50  0001 C CNN
	1    4150 4300
	0    -1   1    0   
$EndComp
$Comp
L ACS712-20A ACS712-20A1
U 1 1 59863649
P 5200 2400
F 0 "ACS712-20A1" V 5200 2400 60  0001 R TNN
F 1 "ACS712-20A" H 5200 2400 60  0001 R TNN
F 2 "Huellas de Componentes DqR:ACS712" H 5200 2400 60  0001 C CNN
F 3 "" H 5200 2400 60  0001 C CNN
	1    5200 2400
	1    0    0    -1  
$EndComp
$Comp
L PowerSupply_5V PowerSupply_5V1
U 1 1 598643CC
P 3350 1700
F 0 "PowerSupply_5V1" H 3350 1700 60  0001 L BNN
F 1 "PowerSupply_5V" H 3350 1700 60  0001 R TNN
F 2 "Huellas de Componentes DqR:PowerSupply5V" H 3350 1700 60  0001 C CNN
F 3 "" H 3350 1700 60  0001 C CNN
	1    3350 1700
	1    0    0    -1  
$EndComp
$Comp
L Relay Relay1
U 1 1 59863DAD
P 7300 1900
F 0 "Relay1" H 7300 1900 60  0001 L BNN
F 1 "Relay" H 7300 1900 60  0001 R TNN
F 2 "Huellas de Componentes DqR:Relay" H 7300 1900 60  0001 C CNN
F 3 "" H 7300 1900 60  0001 C CNN
	1    7300 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	9050 1500 9050 2150
Wire Wire Line
	5800 1500 5800 1050
Connection ~ 7650 1500
Wire Wire Line
	7650 2150 7650 1500
Wire Wire Line
	3800 1300 3800 1800
Connection ~ 5800 1500
Wire Wire Line
	3450 2950 3450 4650
Wire Wire Line
	3450 4100 3900 4100
Wire Wire Line
	4000 2950 4000 4100
Wire Wire Line
	3650 3450 5300 3450
Connection ~ 4000 3450
Wire Wire Line
	5300 2550 4300 2550
Wire Wire Line
	4300 2550 4300 3450
Connection ~ 4300 3450
Wire Wire Line
	5300 3650 3450 3650
Connection ~ 3450 3650
Wire Wire Line
	5300 2750 4500 2750
Wire Wire Line
	4500 2750 4500 3650
Connection ~ 4500 3650
Wire Wire Line
	5300 2650 4750 2650
Wire Wire Line
	4750 2650 4750 3800
Wire Wire Line
	4750 3800 4100 3800
Wire Wire Line
	4100 3800 4100 4100
Wire Wire Line
	5300 3550 4850 3550
Wire Wire Line
	4850 3550 4850 3900
Wire Wire Line
	4850 3900 4200 3900
Wire Wire Line
	4200 3900 4200 4100
Wire Wire Line
	7450 2150 7450 2750
Wire Wire Line
	7450 2750 6250 2750
Wire Wire Line
	6250 3650 7100 3650
Wire Wire Line
	7100 3650 7100 3000
Wire Wire Line
	7100 3000 9250 3000
Wire Wire Line
	9250 3000 9250 2150
Wire Wire Line
	6250 2550 6200 2550
Wire Wire Line
	6200 2550 6200 1050
Wire Wire Line
	6250 3450 6000 3450
Wire Wire Line
	6000 3450 6000 1050
Wire Wire Line
	8950 3400 8950 4650
Wire Wire Line
	8950 4650 3450 4650
Connection ~ 3450 4100
Wire Wire Line
	7550 3400 7550 4650
Connection ~ 7550 4650
Wire Wire Line
	9050 3400 9050 4850
Wire Wire Line
	9050 4850 3650 4850
Wire Wire Line
	3650 4850 3650 3450
Wire Wire Line
	7650 3400 7650 4850
Connection ~ 7650 4850
$Comp
L Relay Relay2
U 1 1 59863DC1
P 8700 1900
F 0 "Relay2" H 8700 1900 60  0001 L BNN
F 1 "Relay" H 8700 1900 60  0001 R TNN
F 2 "Huellas de Componentes DqR:Relay" H 8700 1900 60  0001 C CNN
F 3 "" H 8700 1900 60  0001 C CNN
	1    8700 1900
	1    0    0    -1  
$EndComp
NoConn ~ 8850 2150
NoConn ~ 7850 2150
Wire Wire Line
	4500 1500 9050 1500
Wire Wire Line
	4500 1500 4500 2100
Wire Wire Line
	4500 2100 3650 2100
Wire Wire Line
	3650 2100 3650 1800
Wire Wire Line
	3800 1300 5600 1300
Wire Wire Line
	5600 1300 5600 1050
Wire Wire Line
	7750 3400 7750 4050
Wire Wire Line
	7750 4050 4400 4050
Wire Wire Line
	4400 4050 4400 4100
Wire Wire Line
	9150 3400 9150 3900
Wire Wire Line
	9150 3900 5250 3900
Wire Wire Line
	5250 3900 5250 4000
Wire Wire Line
	5250 4000 4300 4000
Wire Wire Line
	4300 4000 4300 4100
$EndSCHEMATC
