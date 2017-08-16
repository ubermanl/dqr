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
P 5550 2700
F 0 "ACS712-20A2" V 5550 2700 60  0001 R TNN
F 1 "ACS712-20A" H 5550 2700 60  0001 R TNN
F 2 "Huellas de Componentes DqR:ACS712" H 5550 2700 60  0001 C CNN
F 3 "" H 5550 2700 60  0001 C CNN
	1    5550 2700
	1    0    0    -1  
$EndComp
Text Label 5900 3000 0    60   ~ 0
ACS_Relay_2
Text Label 5900 2450 0    60   ~ 0
ACS_Relay_1
$Comp
L Relay Relay1
U 1 1 59863DAD
P 7000 1550
F 0 "Relay1" H 7000 1550 60  0001 L BNN
F 1 "Relay" H 7000 1550 60  0001 R TNN
F 2 "Huellas de Componentes DqR:Relay" H 7000 1550 60  0001 C CNN
F 3 "" H 7000 1550 60  0001 C CNN
	1    7000 1550
	1    0    0    -1  
$EndComp
$Comp
L Relay Relay2
U 1 1 59863DC1
P 7750 1550
F 0 "Relay2" H 7750 1550 60  0001 L BNN
F 1 "Relay" H 7750 1550 60  0001 R TNN
F 2 "Huellas de Componentes DqR:Relay" H 7750 1550 60  0001 C CNN
F 3 "" H 7750 1550 60  0001 C CNN
	1    7750 1550
	1    0    0    -1  
$EndComp
NoConn ~ 7900 1800
NoConn ~ 7550 1800
$Comp
L Screw_Terminal_1x04 J1
U 1 1 59863F3A
P 6100 1800
F 0 "J1" H 6100 2250 50  0000 C TNN
F 1 "Screw_Terminal_1x04" V 5950 1800 50  0000 C TNN
F 2 "Connectors:bornier4" H 6100 1375 50  0001 C CNN
F 3 "" H 6075 2000 50  0001 C CNN
	1    6100 1800
	0    -1   1    0   
$EndComp
$Comp
L CONN_01X06 J2
U 1 1 5987931C
P 4500 3550
F 0 "J2" H 4500 3900 50  0000 C CNN
F 1 "CONN_01X06" V 4600 3550 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x06_Pitch1.27mm" H 4500 3550 50  0001 C CNN
F 3 "" H 4500 3550 50  0001 C CNN
	1    4500 3550
	0    -1   1    0   
$EndComp
Wire Wire Line
	6000 2100 6000 2000
Connection ~ 5000 2300
Wire Wire Line
	5000 2300 5650 2300
Connection ~ 5100 3050
Wire Wire Line
	5650 2500 5100 2500
Wire Wire Line
	5100 2500 5100 3800
Connection ~ 4250 2800
Wire Wire Line
	4250 2900 4250 2800
Wire Wire Line
	4450 3350 4450 2400
Wire Wire Line
	4450 2400 5650 2400
Wire Wire Line
	4550 3350 4550 2950
Wire Wire Line
	4550 2950 5650 2950
Wire Wire Line
	7100 2600 7100 3050
Wire Wire Line
	7100 2600 8300 2600
Wire Wire Line
	8300 2600 8300 1800
Wire Wire Line
	4650 3350 4650 3250
Wire Wire Line
	4650 3250 6650 3250
Wire Wire Line
	6650 3250 6650 3550
Wire Wire Line
	6650 3550 8200 3550
Wire Wire Line
	8200 3550 8200 3000
Wire Wire Line
	5100 3050 5650 3050
Wire Wire Line
	4250 2800 4050 2800
Wire Wire Line
	4050 2800 4050 3800
Wire Wire Line
	4050 3800 8000 3800
Connection ~ 7250 3800
Wire Wire Line
	7250 3800 7250 3000
Wire Wire Line
	8000 3800 8000 3000
Connection ~ 4050 3350
Connection ~ 5100 3800
Wire Wire Line
	4050 3350 4250 3350
Wire Wire Line
	4350 3350 4350 3300
Wire Wire Line
	4350 3300 4000 3300
Wire Wire Line
	4000 3300 4000 3850
Wire Wire Line
	4000 3850 8100 3850
Wire Wire Line
	5000 2300 5000 3850
Connection ~ 5000 3850
Wire Wire Line
	8100 3850 8100 3000
Connection ~ 7350 3850
Wire Wire Line
	7350 3000 7350 3850
Wire Wire Line
	4750 3350 6600 3350
Wire Wire Line
	6600 3350 6600 3600
Wire Wire Line
	6600 3600 7450 3600
Wire Wire Line
	7450 3600 7450 3000
Connection ~ 5000 2850
Connection ~ 6000 2100
Connection ~ 7350 2100
Wire Wire Line
	8100 2100 8100 1800
Wire Wire Line
	4450 2100 8100 2100
Wire Wire Line
	7350 2100 7350 1800
Wire Wire Line
	4450 1750 4450 2100
Wire Wire Line
	5800 2000 5800 2050
Wire Wire Line
	5800 2050 4600 2050
Wire Wire Line
	4600 2050 4600 1750
$Comp
L PowerSupply_5V-RESCUE-Circuito_de_potencia_genérico PowerSupply_5V1
U 1 1 598643CC
P 4150 1650
F 0 "PowerSupply_5V1" H 4150 1650 60  0001 L BNN
F 1 "PowerSupply_5V" H 4150 1650 60  0001 R TNN
F 2 "Huellas de Componentes DqR:PowerSupply5V" H 4150 1650 60  0001 C CNN
F 3 "" H 4150 1650 60  0001 C CNN
	1    4150 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	4800 2850 5650 2850
Wire Wire Line
	4800 2900 4800 2850
$Comp
L ACS712-20A ACS712-20A1
U 1 1 59863649
P 5550 2150
F 0 "ACS712-20A1" V 5550 2150 60  0001 R TNN
F 1 "ACS712-20A" H 5550 2150 60  0001 R TNN
F 2 "Huellas de Componentes DqR:ACS712" H 5550 2150 60  0001 C CNN
F 3 "" H 5550 2150 60  0001 C CNN
	1    5550 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	6400 2000 6400 2300
Wire Wire Line
	6400 2300 6600 2300
Wire Wire Line
	7150 1800 7150 2500
Wire Wire Line
	7150 2500 6600 2500
Wire Wire Line
	7100 3050 6600 3050
Wire Wire Line
	6200 2000 6200 2850
Wire Wire Line
	6200 2850 6600 2850
$EndSCHEMATC
