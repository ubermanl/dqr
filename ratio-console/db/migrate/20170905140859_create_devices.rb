class CreateDevices < ActiveRecord::Migration
  def self.up
    create_table :devices, id:false do |t|
      t.integer :id, null: false
      t.string :name
      t.references :ambience
      t.string :network_identifier
      t.boolean :deleted, null:false, default:false
      t.boolean :disabled, null:false, default:false 
      t.timestamps null: false
    end
    
    execute 'alter table devices add primary key(id)'
  end
  def self.down
    drop_table :devices
  end
end
