# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ModuleType.create([
    { name: 'DqR Lux' },
    { name: 'DqR Omni' },
    { name: 'DqR Potentia' }
                  ])

Ambience.create([
    { name:'Cocina'},
    { name:'Habitación Principal'},
    { name:'Habitación Invitados'},
    { name:'Patio Trasero'},
    { name:'Patio Delantero'}

])

Scene.create(
 [
     { name: 'None' }
 ]
)

SensorType.create([
  {name: 'PIR - Presence', unit: '', max_value: 1, min_value: 0},
  {name: 'TEM - Temperature',unit: 'deg', max_value: 100, min_value: 0},
  {name: 'SND - Sound',unit: 'db', max_value: 1024, min_value: 0},
  {name: 'TCH - Touch Button',unit: '', max_value:1, min_value:0},
  {name: 'LUM - Luminosity',unit: 'lux', max_value:1024, min_value:0},
  {name: 'AMP - Power Consumption',unit: 'amp', max_value:512, min_value:0}
])

User.create([
    { name: 'Administrador', login:'admin', password:'admin', password_confirmation:'admin' }
])

# configuracion de un dispositivo
d1 = Device.create name:'Prueba1', ambience_id: 1, model:'Base', network_identifier:0, scene_id: 1

# modulo LUX
m1 = d1.device_modules.create module_type_id: 1
m1.sensors.create sensor_type_id: 1
m1.sensors.create sensor_type_id: 3
m1.sensors.create sensor_type_id: 4
m1.sensors.create sensor_type_id: 5

# modulo POTENTIA
m2 = d2.device_modules.create module_type_id: 3
m2.sensors.create sensor_type_id: 5
