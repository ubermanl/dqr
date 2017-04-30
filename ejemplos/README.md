
###Archivos en este directorio:

* RNA-MLPClassifier: Ejemplos de RNA usando el algoritmo clasificador (salida 0 o 1). El nivel de confianza pasa a ser un poco transparente para nosotros.
	* RNA Monoambiente v1.ipynb: Ejemplo inicial. Usa un dataset con datos ficticios para entrenar una RNA.
	* dataset.txt.gz: Dataset comprimido. Descomprimir en el mismo direcorio (pero no incluir en git) antes de empezar.
	* generar-dataset.sh: Script usado par agenerar el dataset usado como ejemplo para entrenar la RNA.
	* RNA Monoambiente con servicio y consulta por API.md: Ejemplo de RNA que corre como servicio y escucha consultas por API
	* rna-monoambiente.py: Realiza entrenamiento de la RNA y corre un ejemplo con un dato prefijado.
	* rna-engine
		* rna-engine.sh : Corre la RNA como servicio y se queda escuchando consultas por API.
		* swagger_server : Estructura Flask realizada con Swagger (API que opera con la RNA)
			* controllers: ambiente_controller.py: Contiene metodos de get (consumo) de la RNA a traves de la API


TODO:

1. Cambiar sensor de presencia de decimal a entero
2. Hacer ejemplo usando el algoritmo regresor en vez del clasificador
3. Hacer "Clustering" de los días (para agrupar los días con hábitos similares) antes de correr la clasificación/regresión sobre todo el dataset?
