class CreateDeviceEvents < ActiveRecord::Migration
  def change
    create_table :device_events do |t|
      t.integer :device_id, null: false 
      t.integer :module_id, null: false
      t.boolean :state, null:false, default:false
      t.timestamp :ts, null:false
    end
  end
end
