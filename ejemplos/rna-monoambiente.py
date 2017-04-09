#!/usr/bin/python3

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier
from sklearn import metrics


df = pd.read_csv("./dataset.txt")
del df['idSensor']
del df['sensCorriente']

num_obs = len(df)
num_true = len(df.loc[df['estadoLuz'] == 1])
num_false = len(df.loc[df['estadoLuz'] == 0])
feature_col_names = ['mes', 'diaSemana', 'hora', 'minuto', 'sensLuminosidad', 'sensSonido', 'sensPresencia']
predicted_class_names = ['estadoLuz']
X = df[feature_col_names].values     # Columnas del predictor (7 X m)
y = df[predicted_class_names].values # Clase predecida (1=verdadero, 0=falso) column (1 X m)
split_test_size = 0.30               # 0.30 es 30%, el tamaño para pruebas
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=split_test_size, random_state=0)

print("--------------- Análisis del dataset ---------------")
print("Verdaderos en el total     : {0} ({1:0.2f}%)".format(len(df.loc[df['estadoLuz'] == 1]), (len(df.loc[df['estadoLuz'] == 1])/len(df.index)) * 100.0))
print("Falsos en el total         : {0} ({1:0.2f}%)".format(len(df.loc[df['estadoLuz'] == 0]), (len(df.loc[df['estadoLuz'] == 0])/len(df.index)) * 100.0))
print("")
print("Verdaderos en entrenamiento: {0} ({1:0.2f}%)".format(len(y_train[y_train[:] == 1]), (len(y_train[y_train[:] == 1])/len(y_train) * 100.0)))
print("Falsos en entrenamiento    : {0} ({1:0.2f}%)".format(len(y_train[y_train[:] == 0]), (len(y_train[y_train[:] == 0])/len(y_train) * 100.0)))
print("")
print("Verdaderos en test         : {0} ({1:0.2f}%)".format(len(y_test[y_test[:] == 1]), (len(y_test[y_test[:] == 1])/len(y_test) * 100.0)))
print("Falsos en test             : {0} ({1:0.2f}%)".format(len(y_test[y_test[:] == 0]), (len(y_test[y_test[:] == 0])/len(y_test) * 100.0)))
print()
print("------------------- Performance --------------------")

clf_model = MLPClassifier(random_state=0)
clf_model.fit(X_train, y_train.ravel())

# Entrenamiento
clf_predict_train = clf_model.predict(X_train)
print("Precisión en entrenamiento: {0:.4f}".format(metrics.accuracy_score(y_train, clf_predict_train)))

# Test
clf_predict_test = clf_model.predict(X_test)
print("Precisión en test: {0:.4f}".format(metrics.accuracy_score(y_test, clf_predict_test)))
print()

print ("Matriz de confusión:")
print("{0}".format(metrics.confusion_matrix(y_test, clf_predict_test, labels=[1, 0])))
print()
print("Reporte de clasificación:")
print(metrics.classification_report(y_test, clf_predict_test, labels=[1,0]))

print("----------------------------------------------------")


