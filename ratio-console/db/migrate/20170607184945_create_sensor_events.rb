class CreateSensorEvents < ActiveRecord::Migration
  def change
    create_table :sensor_events do |t|
      t.references :device_sensor, index: true, foreign_key: true, null: false
      t.decimal :value, precision:10, scale:4
      t.timestamp :created_at
    end
  end
end
