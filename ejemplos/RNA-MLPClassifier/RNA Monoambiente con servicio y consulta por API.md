##RNA Monoambiente con servicio y consulta por API

Este ejemplo usa el mismo código que el ejemplo inicial, pero está adaptado para correr como un servicio, aceptando consultas por medio de una api hecha con swagger
Inicio del servicio. Por ahora no tengo un archivo de systemd, así que inicio el script a mano:
```
$ ./rna-engine.sh >> ./rna-engine.log 2>&1 & 
[1] 31446
$
```

Contenido del log hasta ahora:
```
$ cat rna-engine.log 
Cargando el dataset
Separando los datos para entrenamiento y test
Análisis de los datos en el dataset:
Verdaderos en el total     : 28506 (22.00%)
Falsos en el total         : 101095 (78.00%)

Verdaderos en entrenamiento: 20018 (22.07%)
Falsos en entrenamiento    : 70702 (77.93%)

Verdaderos en test         : 8488 (21.83%)
Falsos en test             : 30393 (78.17%)

Entrenando la RNA
Precisión en entrenamiento: 0.9770
Ejecutando las pruebas con datos en el dataset
Precisión en test: 0.9769
Matriz de confusión:
[[ 8427    61]
 [  837 29556]]
Reporte de clasificación:
             precision    recall  f1-score   support

          1       0.91      0.99      0.95      8488
          0       1.00      0.97      0.99     30393

avg / total       0.98      0.98      0.98     38881

Cargando la api
 * Running on http://127.0.0.1:8080/ (Press CTRL+C to quit)
$
```

Hasta ahora es muy similar al ejemplo anterior, carga el dataset, entrena la red neuronal, pero en vez de correr un ejemplo y salir, se queda escuchando en una url.
La especificación de esta API, en el archivo swagger_server/swagger/swagger.yaml, indica que se debe llamar a este método con los siguientes parámetros:
```
/getEstadoSugerido/{luxId}/{mes}/{diaSemana}/{minuto}/{sensLuminosidad}/{sensSonido}/{sensPresencia}
```

Entonces, si el momento a consultar fuera "Martes 25 de Abril a las 21:20hs, con valores normales de luz, sonido y presencia", mi llamada a la url sería la siguiente:
```
$ curl -v http://localhost:8080/getEstadoSugerido/1001/4/2/1280/0.3/0.4/0.4
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8080 (#0)
> GET /getEstadoSugerido/1001/4/2/1280/0.3/0.4/0.4 HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.51.0
> Accept: */*
> 
* HTTP 1.0, assume close after body
< HTTP/1.0 200 OK
< Content-Type: text/html; charset=utf-8
< Content-Length: 1
< Server: Werkzeug/0.12.1 Python/3.5.3
< Date: Mon, 24 Apr 2017 01:35:46 GMT
< 
* Curl_http_done: called premature == 0
* Closing connection 0
1 
$
```

Fijense que devuelve 1, como es de esperar.

Si hiciera una consulta en la que no se detecta sonido o presencia:
```
$ curl -v http://localhost:8080/getEstadoSugerido/1001/4/2/1280/0.3/0.03/0.02
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8080 (#0)
> GET /getEstadoSugerido/1001/4/2/21/20/0.3/0.03/0.02 HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.51.0
> Accept: */*
> 
* HTTP 1.0, assume close after body
< HTTP/1.0 200 OK
< Content-Type: text/html; charset=utf-8
< Content-Length: 1
< Server: Werkzeug/0.12.1 Python/3.5.3
< Date: Mon, 24 Apr 2017 01:37:24 GMT
< 
* Curl_http_done: called premature == 0
* Closing connection 0
0 
$
```

En este caso la respuesta es cero, como es de esperar.

Verifico la información que provee el log luego de las consultas:
```
$ tail rna-engine.log 
          1       0.91      0.99      0.95      8488
          0       1.00      0.97      0.99     30393

avg / total       0.98      0.98      0.98     38881

Cargando la api
 * Running on http://127.0.0.1:8080/ (Press CTRL+C to quit)
127.0.0.1 - - [23/Apr/2017 22:35:30] "GET /getEstadoSugerido/1001/4/2/1280/0.3/0.4/0.4 HTTP/1.1" 200 -
127.0.0.1 - - [23/Apr/2017 22:35:46] "GET /getEstadoSugerido/1001/4/2/1280/0.3/0.4/0.4 HTTP/1.1" 200 -
127.0.0.1 - - [23/Apr/2017 22:37:24] "GET /getEstadoSugerido/1001/4/2/1280/0.3/0.03/0.02 HTTP/1.1" 200 -
$
```


