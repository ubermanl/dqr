generar-dataset.sh: Genera el dataset.txt con los datos de la muestra a entrenar la RNA
rna-monoambiente.py: Realiza entrenamiento de la RNA y corre un ejemplo con un dato prefijado.

rna-engine: Estructura Flask realizada con Swagger (API que opera con la RNA)
	- controllers: ambiente_controller.py: Contiene metodos de get (consumo) de la RNA a traves de la API
