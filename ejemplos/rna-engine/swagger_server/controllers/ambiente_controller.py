import connexion
from datetime import date, datetime
from typing import List, Dict
from six import iteritems
from ..util import deserialize_date, deserialize_datetime

#
# Módulos necesarios para la RNA
#
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier
from sklearn import metrics

#
# Importo el dataset y acomodo los datos un poco
#
print("Cargando el dataset")
df = pd.read_csv("../dataset.txt")
del df['idSensor']
del df['sensCorriente']
del df['sensLuminosidad']

#
# Incio de la carga de la RNA
#
num_obs = len(df)
num_true = len(df.loc[df['estadoLuz'] == 1])
num_false = len(df.loc[df['estadoLuz'] == 0])
#feature_col_names = ['mes', 'diaSemana', 'hora', 'minuto', 'sensLuminosidad', 'sensSonido', 'sensPresencia']
feature_col_names = ['mes', 'diaSemana', 'hora', 'minuto', 'sensSonido', 'sensPresencia']
predicted_class_names = ['estadoLuz']
X = df[feature_col_names].values     # Columnas del predictor (7 X m)
y = df[predicted_class_names].values # Clase predecida (1=verdadero, 0=falso) column (1 X m)
split_test_size = 0.30               # 0.30 es 30%, el tamaño para pruebas

print("Separando los datos para entrenamiento y test")
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=split_test_size, random_state=0)

print("Análisis de los datos en el dataset:")
print("Verdaderos en el total     : {0} ({1:0.2f}%)".format(len(df.loc[df['estadoLuz'] == 1]), (len(df.loc[df['estadoLuz'] == 1])/len(df.index)) * 100.0))
print("Falsos en el total         : {0} ({1:0.2f}%)".format(len(df.loc[df['estadoLuz'] == 0]), (len(df.loc[df['estadoLuz'] == 0])/len(df.index)) * 100.0))
print("")
print("Verdaderos en entrenamiento: {0} ({1:0.2f}%)".format(len(y_train[y_train[:] == 1]), (len(y_train[y_train[:] == 1])/len(y_train) * 100.0)))
print("Falsos en entrenamiento    : {0} ({1:0.2f}%)".format(len(y_train[y_train[:] == 0]), (len(y_train[y_train[:] == 0])/len(y_train) * 100.0)))
print("")
print("Verdaderos en test         : {0} ({1:0.2f}%)".format(len(y_test[y_test[:] == 1]), (len(y_test[y_test[:] == 1])/len(y_test) * 100.0)))
print("Falsos en test             : {0} ({1:0.2f}%)".format(len(y_test[y_test[:] == 0]), (len(y_test[y_test[:] == 0])/len(y_test) * 100.0)))
print()

print("Entrenando la RNA")
clf_model = MLPClassifier(random_state=0)
clf_model.fit(X_train, y_train.ravel())

clf_predict_train = clf_model.predict(X_train)
print("Precisión en entrenamiento: {0:.4f}".format(metrics.accuracy_score(y_train, clf_predict_train)))

print("Ejecutando las pruebas con datos en el dataset")
clf_predict_test = clf_model.predict(X_test)
print("Precisión en test: {0:.4f}".format(metrics.accuracy_score(y_test, clf_predict_test)))

print ("Matriz de confusión:")
print("{0}".format(metrics.confusion_matrix(y_test, clf_predict_test, labels=[1, 0])))
print("Reporte de clasificación:")
print(metrics.classification_report(y_test, clf_predict_test, labels=[1,0]))

print ("Cargando la api")

def get_estado_sugerido(luxId, mes, diaSemana, hora, minuto, sensLuminosidad, sensSonido, sensPresencia):
    """
    Consultar el estado sugerido de un dispositivo Lux
    Método para consultar el estado sugerido de un dispositivo DqR Lux, en un momento dado
    :param luxId: ID del dispositivo
    :type luxId: int
    :param mes: Mes por la que se hace la consulta
    :type mes: int
    :param diaSemana: Dia dela semana por la que se hace la consulta. Lunes &#x3D; 1, etc.
    :type diaSemana: int
    :param hora: Hora por la que se hace la consulta
    :type hora: int
    :param minuto: Minuto por el que se hace la consulta
    :type minuto: int
    :param sensLuminosidad: valor del sensor de luminosidad
    :type sensLuminosidad: float
    :param sensSonido: valor del sensor de sonido
    :type sensSonido: float
    :param sensPresencia: valor del sensor de presencia
    :type sensPresencia: float

    :rtype: None
    """
    X_new_test = [[mes, diaSemana, hora, minuto, sensSonido, sensPresencia]]
    #return clf_model.predict(X_new_test)
    clf_predict_new_test = clf_model.predict(X_new_test)[0]
    return str(clf_predict_new_test)



