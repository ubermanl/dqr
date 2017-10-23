namespace :app do
  desc "Recompone desde cero la base de datos"
  task rebuild: :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end
  
  task update_units: :environment do
     # pega todos los updates en los modelos
    updates = {
      1 => { unit: 'mAmp'},
      2 => { unit: 'lux'},
      3 => { unit: ''},
      4 => { unit: 'dB'},
      5 => { unit: 'C'}
    }
    
    updates.each do |k,v|
      s = SensorType.find(k)
      if s.present?
        s.update_column(:unit,v[:unit])
      end
    end
  end
  
  task :destroy_device, [:device_id] => :environment do |t,args|
    puts "Houston, vamos a aterrizar forzosamente, please fasten your seatbealts"
    device_id = args[:device_id].to_i
    device = Device.find_by_id(device_id)
    if !device.present?
      puts "uh ohh... ese dispositivo no existe."
    else
      device.modules.each do |m|
        m.sensors.delete_all
      end
      device.modules.delete_all
      device.delete
      puts "Done. Aqui no ha pasado nada"
    end
  end
  
  desc "Genera un dispositivo en la tabla de dispositivos"
  task :generate_device, [:device_id] => :environment do |t,args|
    device_id = args[:device_id].to_i
    puts 'Verificando...'
    if Device.where(:id => device_id).any?
      puts 'El Device que intenta generar ya existe'
    else
      puts 'Creando el dispositivo...'
      module_id = "#{device_id}1".to_i
      # ------------ CREA EL DISPOSITIVO CON ID 3
      Device.create(id: device_id, name: "DQR TestDrive ID#{device_id}",ambience_id: 2, network_identifier:'0x0000',deleted: false, disabled: false)
      DeviceModule.create(id: module_id, device_id: device_id, module_type_id: 1, disabled: false)
          .sensors    
          .create([           
              { sensor_type_id: 1},   # un acs
              { sensor_type_id: 2},   # un lum
              { sensor_type_id: 3},   # un pir
              { sensor_type_id: 4},   # un snd
              ]
          )
      
      module_id = module_id + 1
      DeviceModule.create(id: module_id, device_id: device_id, module_type_id: 2, disabled: false)
          .sensors
          .create([
              { sensor_type_id: 1}  # un acs
          ])
          
      puts '-----------------------------------------------------------------------------------------'
      puts 'HOUSTON'
      puts "                   hemos recibido el dispositivo 'DQR TestDrive ID#{device_id}', esperando ordenes!"
      puts '-----------------------------------------------------------------------------------------'
    end
  end
  desc "Genera un dispositivo en la tabla de dispositivos"
  task :generate_device_lux, [:device_id] => :environment do |t,args|
    device_id = args[:device_id].to_i
    puts 'Verificando...'
    if Device.where(:id => device_id).any?
      puts 'El Device que intenta generar ya existe'
    else
      puts 'Creando el dispositivo...'
      module_id = "#{device_id}1".to_i
      # ------------ CREA EL DISPOSITIVO CON ID 3
      Device.create(id: device_id, name: "DQR TestDrive ID#{device_id}",ambience_id: 2, network_identifier:'0x0000',deleted: false, disabled: false)
      DeviceModule.create(id: module_id, device_id: device_id, module_type_id: 2, disabled: false)
          .sensors
          .create([
              { sensor_type_id: 1}  # un acs
          ])
          
      puts '-----------------------------------------------------------------------------------------'
      puts 'HOUSTON'
      puts "                   hemos recibido el dispositivo 'DQR TestDrive ID#{device_id}', esperando ordenes!"
      puts '-----------------------------------------------------------------------------------------'
    end
  end
  
  task :purge_device_events, [:device_id] => :environment do |t,args|
    
  end
end
