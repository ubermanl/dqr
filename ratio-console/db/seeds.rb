# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
DeviceType.create([
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

User.create([
    { name: 'Administrador', login:'admin', password:'admin', password_confirmation:'admin' }
            ])