class CreateDeviceStates < ActiveRecord::Migration
  def self.up
    create_table :device_states, id:false do |t|
      t.integer :id, null: false
      t.string :name, null: false
    end
    
    execute 'alter table device_states add primary key(id)'
  end
  
  def self.down
    drop_table :device_states
  end
end
