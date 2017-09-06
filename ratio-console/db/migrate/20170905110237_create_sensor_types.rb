class CreateSensorTypes < ActiveRecord::Migration
  def self.up
    create_table :sensor_types, id:false do |t|
      t.integer :id, null: false
      t.string :name
      t.timestamps null: false
    end
    
    execute 'alter table sensor_types add primary key(id)' 
  end
  def self.down
    drop_table :sensor_types
  end
end
