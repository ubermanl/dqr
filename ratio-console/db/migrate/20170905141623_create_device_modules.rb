class CreateDeviceModules < ActiveRecord::Migration
  def self.up 
    create_table :device_modules, id:false do |t|
      t.integer :id, null:false 
      t.references :device, index: true, foreign_key: true
      t.references :module_type, index: true, foreign_key: true
      t.boolean :disabled, null:false,default:false
      t.timestamps null: false
    end
    
    execute 'alter table device_modules add primary key (id)'
  end
  def self.down
    drop_table :device_modules
  end
end
