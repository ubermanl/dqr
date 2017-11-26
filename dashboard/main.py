from flask import Flask, request, render_template
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import math as math
import json
from datetime import datetime, timedelta
import MySQLdb
from sqlalchemy import create_engine
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPRegressor
pd.options.mode.chained_assignment = None  # default='warn'

### CONFIGURATION ###
# TRX DB Config
dbname_trx = "ratio_dev_eric"
dbhost_trx = "localhost"
dbport_trx = 3306
dbuser_trx = "root"
dbpass_trx = "root"

# DWH DB Config
dbname_hist = "ratio_dwh"
dbhost_hist = "localhost"
dbport_hist = 3306
dbuser_hist = "root"
dbpass_hist = "root"

# TRX Tables
devices_tbl = "devices"
device_modules_tbl = "device_modules"
module_types_tbl = "module_types"
sensor_types_tbl = "sensor_types"
device_events_tbl = "device_events"
device_event_sensors_tbl = "device_event_sensors"

# DWH Tables
agg_power_consumption = "agg_power_consumption"
agg_power_consumption_cols = [ 'TIMESTAMP', 'MOD_ID', 'WATT_HOUR', 'WATT_HOUR_ACC', 'TOTAL_WATT_PER' ]
agg_power_consumption_cols_ext = agg_power_consumption_cols + ['YEARMONTH']
lk_module = "lk_module"
lk_module_cols = [ 'MOD_ID', 'MOD_NAME', 'MOD_TYPE_ID', 'MOD_TYPE_NAME', 'DEV_ID', 'DEV_NAME' ]
lk_time = "lk_time"
lk_time_cols = [ 'TIMESTAMP', 'YEAR', 'YEARDAY', 'MONTH', 'YEARMONTH', 'WEEKDAY', 'WEEKDAY_NAME', 'DAY	HOUR', 'MONTH_HOUR', 'MINUTE', 'MINDAY' ]
lk_sensor = "lk_sensor"
lk_sensor_cols = [ 'SENSOR_TYPE_ID', 'SENSOR_TYPE_NAME', 'UNIT' ]
bt_events = "bt_events"
bt_events_cols = [ 'MOD_ID', 'TIMESTAMP', 'SENSOR_TYPE_ID', 'SENSED_VALUE' ]

### GLOBAL VARIABLES ###
app = Flask(__name__)
voltage = 230
current_sensor_type_id = 1
min_hitorical_date = 'DATE_SUB(NOW(), INTERVAL 1 MONTH)'
# Partial Dataframes
df_modules = pd.DataFrame(columns=lk_module_cols)
df_time = pd.DataFrame(columns=lk_time_cols)
df_sensors = pd.DataFrame(columns=lk_sensor_cols)
df_events = pd.DataFrame(columns=bt_events_cols)
df_power = pd.DataFrame(columns=agg_power_consumption_cols)
power_prediction_models = {}


### FUNCTIONS ###
def get_modules_data():
    conn = MySQLdb.connect(host=dbhost_hist, port=dbport_hist, user=dbuser_hist, passwd=dbpass_hist, db=dbname_hist)
    return pd.read_sql('SELECT ' + ','.join(['%s' % x for x in lk_module_cols]) + ' FROM ' + lk_module, con=conn)
    conn.close()

def get_sensors_data():
    conn = MySQLdb.connect(host=dbhost_hist, port=dbport_hist, user=dbuser_hist, passwd=dbpass_hist, db=dbname_hist)
    return pd.read_sql('SELECT ' + ','.join(['%s' % x for x in lk_sensor_cols]) + ' FROM ' + lk_sensor, con=conn)
    conn.close()

def get_time_data():
    conn = MySQLdb.connect(host=dbhost_hist, port=dbport_hist, user=dbuser_hist, passwd=dbpass_hist, db=dbname_hist)
    return pd.read_sql('SELECT ' + ','.join(['%s' % x for x in lk_time_cols]) + ' FROM ' + lk_time, con=conn)
    conn.close()

def get_events_data():
    conn = MySQLdb.connect(host=dbhost_hist, port=dbport_hist, user=dbuser_hist, passwd=dbpass_hist, db=dbname_hist)
    #return pd.read_sql('SELECT ' + ','.join(['%s' % x for x in bt_events_cols]) + ' FROM ' + bt_events + ' WHERE SENSOR_TYPE_ID <> ' + str(current_sensor_type_id) + ' AND TIMESTAMP > ' + min_hitorical_date, con=conn)
    return pd.read_sql('SELECT ' + ','.join(['%s' % x for x in bt_events_cols]) + ' FROM ' + bt_events + ' WHERE SENSOR_TYPE_ID <> ' + str(current_sensor_type_id), con=conn)
    conn.close()

def get_power_data():
    conn = MySQLdb.connect(host=dbhost_hist, port=dbport_hist, user=dbuser_hist, passwd=dbpass_hist, db=dbname_hist)
    return pd.read_sql('SELECT ' + ','.join(['%s' % x for x in agg_power_consumption_cols]) + ' FROM ' + agg_power_consumption, con=conn)
    conn.close()

def load_data():
    global df_modules
    global df_time
    global df_sensors
    global df_events
    global df_power
    
    try:
        # Load Modules
        df_modules = get_modules_data()
        # Load Times
        df_time = get_time_data()
        # Load Sensors
        df_sensors = get_sensors_data()
        # Load Events
        df_events = get_events_data()
        df_events = df_events.merge(df_modules,on='MOD_ID').merge(df_time,on='TIMESTAMP')
        df_events.drop_duplicates(inplace=True,keep='first')
        df_events.dropna(inplace=True)
        df_events['TIMESTAMP'] = df_events.TIMESTAMP.dt.strftime('%Y-%m-%d %H:%M:%S')
        ### Inicio - Agregado para enviar sensado agrupado en horas en vez de minutos
        sensed_value_hours = pd.DataFrame(df_events.groupby(['YEARDAY','HOUR','MOD_ID','SENSOR_TYPE_ID']).TIMESTAMP.min(),columns=['TIMESTAMP'])
        sensed_value_hours['SENSED_VALUE'] = df_events.groupby(['YEARDAY','HOUR','MOD_ID','SENSOR_TYPE_ID']).SENSED_VALUE.mean()
        df_events = sensed_value_hours.reset_index()
        ### Fin - Agregado
        # Load Power Events
        df_power = get_power_data()
        df_power = df_power.merge(df_modules,on='MOD_ID').merge(df_time,on='TIMESTAMP')
        df_power.drop_duplicates(inplace=True,keep='first')
        df_power.dropna(inplace=True)
        df_power['TIMESTAMP'] = df_power.TIMESTAMP.dt.strftime('%Y-%m-%d %H:%M:%S')
        df_power['WATT_HOUR'] = df_power.WATT_HOUR.interpolate(method='linear')

        #return '{ "req_status": 1, "message": "OK" }'
    except MySQLdb.Error, e:
        #return '{ "req_status": 0, "message": "' + e + '" }'
        print 'Error loading data: {0}'.format(e)

def create_module_regressor(mod_id):
    global df_power
    df_predict_mod = df_power.query('MOD_ID == ' + str(mod_id))
    
    if (df_predict_mod.shape[0] > 0):
        # Data preparation (split 70/30)
        features_names = ['MONTH_HOUR','MONTH']
        target_names = ['TOTAL_WATT_PER']

        features_data = df_predict_mod[features_names].values        # Predictor columns
        target_data = df_predict_mod[target_names].values            # Target to predict
        split_test_size = 0.30                                       # 30% for test

        features_train, features_test, target_train, target_test = train_test_split(features_data, target_data, test_size=split_test_size)

        # Training and evaluation
        mlp = MLPRegressor(solver='lbfgs', hidden_layer_sizes=100, max_iter=300, shuffle=True, activation='identity')
        mlp.fit(features_train, target_train.ravel())

        #print 'Training score for module {0}: {1:.4f}'.format(mod_id,mlp.score(features_test, target_test))

        return mlp
    else:
        return 0
        
def train_prediction():
    global df_power
    global power_prediction_models
    
    df_power = df_power.merge(df_power.groupby(['YEAR','MONTH','MOD_ID']).WATT_HOUR.sum().astype(int).reset_index(), on=['YEAR','MONTH','MOD_ID'])
    df_power = df_power.rename(columns={'WATT_HOUR_x': 'WATT_HOUR', 'WATT_HOUR_y': 'WATT_HOUR_MONTH'})
    df_power['TOTAL_WATT_PER'] = df_power.WATT_HOUR_ACC / df_power.WATT_HOUR_MONTH
    
    for mod_id in df_modules.MOD_ID:
        mlp = create_module_regressor(mod_id)
        if (mlp != 0):
            power_prediction_models[mod_id] = mlp
        
        
### MAIN APP ###

# PreLoad Data from DB
load_data()

# Power Consumption Prediction - Train RNAs
train_prediction()

# Application Pages
@app.route("/")
def index():
    return render_template("power.html")
@app.route("/powerDash")
def powerDash():
    return render_template("power.html")
@app.route("/luminosityDash")
def luminosityDash():
    return render_template("luminosity.html")
@app.route("/soundDash")
def soundDash():
    return render_template("sound.html")
@app.route("/movementDash")
def movementDash():
    return render_template("movement.html")
@app.route("/temperatureDash")
def temperatureDash():
    return render_template("temperature.html")
    
# Application data enpoints
@app.route("/get_data_description")
def get_data_description():
    html = 'Modules: ' + str(df_modules.shape[0]) + '<br>' + \
            'Sensors: ' + str(df_sensors.shape[0]) + '<br>' + \
            'Time: ' + str(df_time.shape[0]) + '<br>' + \
            'Events: ' + str(df_events.shape[0]) + '<br>' + \
            'Power Events: ' + str(df_power.shape[0]) + '<br>'
    return html

@app.route("/get_modules")
def get_modules():
    return df_modules.to_json(orient='records')
    
@app.route("/get_time")
def get_time():
    return df_time.to_json(orient='records')

@app.route("/get_sensors")
def get_sensors():
    return df_sensors.to_json(orient='records')

@app.route("/get_events")
def get_events():
    global bt_events_cols
    error_ret = '{ "req_status": 0, "message": "Sensor Type ID not valid" }'
    try:
        sensor_type_id = request.args.get('sensor_type_id')
        sensor_type_id = int(sensor_type_id)
    except (ValueError, TypeError):
        return error_ret
    
    if (sensor_type_id in list(df_sensors.SENSOR_TYPE_ID)):
        try:
            return df_events[bt_events_cols].query('SENSOR_TYPE_ID == ' + str(sensor_type_id)).to_json(orient='records')
        except AttributeError:
            return '{ "req_status": 0, "message": "Module ID not available for prediction" }'
    else:
        return error_ret
    
@app.route("/get_power_events")
def get_power_events():
    global agg_power_consumption_cols_ext
    return df_power[agg_power_consumption_cols_ext].to_json(orient='records')
    
@app.route("/predict_power")
def predict_power():
    global df_power
    global df_modules
    global power_prediction_models

    error_ret = '{ "req_status": 0, "prediction": 0, "message": "Module ID not valid" }'
    
    try:
        mod_id = request.args.get('mod_id')
        mod_id = int(mod_id)
    except ValueError:
        return error_ret

    if (mod_id in list(df_modules.MOD_ID)):
        try:
            last_event = df_power.query('MOD_ID == ' + str(mod_id) + ' & TIMESTAMP == "' + str(df_power.TIMESTAMP.max()) +'"')
            total_watt_per = power_prediction_models[mod_id].predict(last_event[['MONTH_HOUR','MONTH']])[0]
            result = (last_event.iloc[0].WATT_HOUR_ACC / 1000) / total_watt_per
            return '{ "req_status": 1, "prediction": ' + str(result) + ', "message": "OK" }'
        except AttributeError:
            return '{ "req_status": 0, "prediction": 0, "message": "Module ID not available for prediction" }'
    else:
        return error_ret
  
@app.route("/predict_power_all")
def predict_power_all():
    global df_power
    global power_prediction_models
    
    result = []
    for mod_id in power_prediction_models:
        last_event = df_power.query('MOD_ID == ' + str(mod_id) + ' & TIMESTAMP == "' + str(df_power.TIMESTAMP.max()) +'"')
        total_watt_per = power_prediction_models[mod_id].predict(last_event[['MONTH_HOUR','MONTH']])[0]
        result.append( { 'MOD_ID': int(mod_id), 'WATT_HOUR_MONTH': (last_event.iloc[0].WATT_HOUR_ACC / 1000) / total_watt_per } )
        
    return json.dumps(result)

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=5000,debug=True)