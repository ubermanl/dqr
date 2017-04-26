#!/bin/bash

START=1483239600	# 01-01-2017 00:00hs ART
STOP=1491015600		# START+90 dias (01-04-2017), o sea 129600 registros

X=$START

export estado_anterior=0

# Encabezado
echo "mes,diaSemana,minuto,idSensor,sensCorriente,sensLuminosidad,sensSonido,sensPresencia,estadoLuz"
while [ $X -le $STOP ] ;do 
	#--- cálculo del timestamp ---
	# El timestamp al que corresponde la medicón
	X=$(($X+60))
	# Un cantidad de segundos random menor a 10 para simular la demora que tiene el paquete desde
	# que sale del sensor hasta que se registra en la base de datos
	RAND=$(( ( RANDOM % 5 )  + 1 ))
	# El timestamp que queda registrado en la base de datos
	timeStamp=$(($X+60+$RAND))
	mes=$(date -d "@$timeStamp" +%m| sed 's/^0//')
	diaSemana=$(date -d "@$timeStamp" +%u)

	#--- id del sensor ---
	idSensor=1020

	#--- cálculo del consumo de corriente ---
	# El criterio es:
	# de 00:00:00 a +-07:00, luz apagada. Sin consumo.
	# de +-07:00 a +-07:30, luz prendida. Intensidad de corriente medida entre 250 y 300ma.
	# de +-7:30 a +-18:30, luz apagada. Sin consumo.
	# de +-18:30 a +-19:30 puede estar prendida o apagada, pero hay presencia
	# de +-19:30 a +-23:00, luz prendida.
	# de +-23:00 a 00:00, luz apagada
	HORA=$(date -d "@$X" +%_H| tr -d ' ')
	MINUTO=$(date -d "@$X" +%M| sed 's/^0//')
	MINUTO_RELATIVO=$(($HORA*60 + $MINUTO ))

	if [[ $HORA -ge 0  &&  $HORA -lt 7 ]] ;then
		sensCorriente=0
	elif [[ $HORA -eq 7 && $MINUTO -le 30 ]] ;then
		sensCorriente=$(( ( RANDOM %50 ) + 250 ))
	elif [[ ($HORA -eq 7 && $MINUTO -gt 30) || ($HORA -gt 7 && $HORA -lt 18) || ($HORA -eq 18 && $MINUTO -le 30) ]] ;then
		# Sabados y domingos puede ser que haya consumo durante el día (10% prob apagar/prender durante el día)
		if [ $diaSemana -gt 6 ] ;then
			randomCambio=$(( (RANDOM %100 ) + 1 ))
			if [ $randomCambio -gt 90 ] ;then
				if [ $estado_anterior -eq 1 ] ;then
					export estado_anterior=0
				else
					export estado_anterior=1
				fi
			fi
			if [ $estado_anterior -eq 1 ] ;then
				sensCorriente=$(( ( RANDOM %50 ) + 250 ))
			else
				sensCorriente=0
			fi
		else
			sensCorriente=0
		fi
	elif [[ ($HORA -eq 18 && $MINUTO -gt 30) || ($HORA -eq 19 && $MINUTO -lt 30) ]] ;then
		# Durante esta hora voy a ver el estado anterior y mantenerlo con un 90% de probabilidades
		# o sea, el usuario puede prender y apagar, pero no constantemente
		if [ $(( (RANDOM %100 ) + 1 )) -ge 90 ] ;then
			if [ $estado_anterior -eq 1 ] ;then
				export estado_anterior=0
			else
				export estado_anterior=1
			fi
		fi
		if [ $estado_anterior -eq 1 ] ;then
			sensCorriente=$(( ( RANDOM %50 ) + 250 ))
		else
			sensCorriente=0
		fi

	elif [[ $HORA -eq 19 && $MINUTO -gt 30 ]] ;then
		sensCorriente=$(( ( RANDOM %50 ) + 250 ))
	elif [[ $HORA -gt 19 && $HORA -lt 23 ]] ;then
		sensCorriente=$(( ( RANDOM %50 ) + 250 ))
	elif [ $HORA -eq 23 ] ;then
		sensCorriente=0
	fi

	#--- sensor de luminosidad, depende del estado del sensor de corriente ---
	if [ $sensCorriente -eq 0 ] ;then
		if [ $HORA -lt 6 ] ; then
			sensLuminosidad="0.0$(( ( RANDOM % 10 ) +20))"
		elif [ $HORA -lt 7 ] ; then
			sensLuminosidad="0.0$(( ( RANDOM % 10 ) +40))"
		elif [[ $HORA -eq 7 && $MINUTO -le 29 ]] ;then
			sensLuminosidad="0.0$(( ( RANDOM % 10 ) +50))"
		elif [[ $HORA -gt 7 && $HORA -lt 19 ]] ;then
			# luz natural
			sensLuminosidad="0.$(( ( RANDOM % 90 ) +400))"
		fi
	else
		# si la luz está prendida, la luminosidad está entre 750 y 850 lumens
		sensLuminosidad="0.$(( ( RANDOM %100 ) + 750 ))"
	fi

	#--- sensor de sonido ---
	# cuando la luz está apagada durante la noche, el nivel de sonido es muy bajo
	# cuando está prendida puede haber ruido a un nivel moderado
	# entre las 18:30 y las 23:00 puede haber un volumen más alto si la tele está prendida
	if [[ $HORA -ge 0 && $HORA -lt 7 && $sensCorriente -eq 0 ]] ;then
		sensSonido="0.0$(( ( RANDOM %50 ) + 40 ))"
	elif [[ ($HORA -eq 7 && $MINUTO -le 30) ]] ;then
		sensSonido="0.$(( ( RANDOM %50 ) + 400 ))"
	elif [[ ($HORA -eq 7 && $MINUTO -gt 30) || ($HORA -gt 7 && $HORA -lt 18) ]] ;then
		sensSonido="0.$(( ( RANDOM %50 ) + 100 ))"
		if [ $sensCorriente -gt 0 ] ;then
			sensSonido="0.$(( ( RANDOM %50 ) + 600 ))"
		fi
	elif [[ $HORA -eq 18 && $MINUTO -le 30 ]] ;then
		sensSonido="0.$(( ( RANDOM %50 ) + 100 ))"
	elif [[ ($HORA -eq 18 && $MINUTO -gt 30) || ($HORA -eq 19 && $HORA -le 22) ]] ;then
		sensSonido="0.$(( ( RANDOM %50 ) + 250 ))"
	elif [ $HORA -eq 23 ] ;then
		sensSonido="0.$(( ( RANDOM %50 ) + 100 ))"
	fi
	
	#--- sensor de presencia ---
	# Puede haber detección de presencia mientras el usuario está durmiendo (10% de prob)
	# En general, hay detección de presencia cuando hay ruido sobre todo de 7:00 a 7:30 (60%)
	# Durante las horas de ausencia, no se detecta presencia,con un 95% de probabilidades (se mueve la cortina, etc 5%)
	# Después de las 18:30, independientemente de los otros sensores, 80% de prob de detectar presencia
	if [[ $HORA -ge 0  &&  $HORA -lt 7 ]] ;then
		if [ $(( RANDOM %100 )) -le 10 ] ;then
			sensPresencia="0.$(( ( RANDOM %200 ) + 100 ))"
		else
			sensPresencia="0.0$(( ( RANDOM %10 ) + 1 ))"
		fi
	elif [[ $HORA -eq 7 && $MINUTO -le 30 ]] ;then
		if [ $(( RANDOM %100 )) -le 60 ] ;then
			sensPresencia="0.$(( ( RANDOM %400 ) + 100 ))"
		else
			sensPresencia="0.0$(( ( RANDOM %100 ) + 1 ))"
		fi
	elif [[ ($HORA -eq 7 && $MINUTO -gt 30) || ($HORA -gt 7 && $HORA -lt 18) ]] ;then
		if [ $(( RANDOM %100 )) -le 95 ] ;then
			sensPresencia="0.$(( ( RANDOM %50 ) + 100 ))"
		else
			sensPresencia="0.0$(( ( RANDOM %10 ) + 1 ))"
		fi
		if [ $diaSemana -ge 6 ] ;then
			sensPresencia="0.$(( ( RANDOM %400 ) + 100 ))"
		fi
	elif [[ $HORA -eq 18 && $MINUTO -le 30 ]] ;then
		if [ $(( RANDOM %100 )) -le 95 ] ;then
			sensPresencia="0.$(( ( RANDOM %100 ) + 100 ))"
		else
			sensPresencia="0.0$(( ( RANDOM %10 ) + 1 ))"
		fi
	elif [[ ($HORA -eq 18 && $MINUTO -gt 30) || ($HORA -eq 19 && $HORA -le 22) ]] ;then
		if [ $(( RANDOM %100 )) -le 80 ] ;then
			sensPresencia="0.$(( ( RANDOM %400 ) + 100 ))"
		else
			sensPresencia="0.$(( ( RANDOM %100 ) + 100 ))"
		fi
	elif [ $HORA -eq 23 ] ;then
		sensPresencia="0.0$(( ( RANDOM %100 ) + 1 ))"
	fi
	
	
	#--- estado de la luz ---
	# Si el sensor de corriente tiene medición, entonces no cabe otra que la luz esté prendida
	if [ $sensCorriente -gt 0 ] ;then
		estadoLuz=1
	else
		estadoLuz=0
	fi
	

	# Ahora, a la red neuronal, no le paso el dato de medición de corriente.
	# Pretendo que determine el valor de la relación de los otros campos.

	LINE="$mes,$diaSemana,$MINUTO_RELATIVO,$idSensor,$sensCorriente,$sensLuminosidad,$sensSonido,$sensPresencia,$estadoLuz"
	echo $LINE
done
