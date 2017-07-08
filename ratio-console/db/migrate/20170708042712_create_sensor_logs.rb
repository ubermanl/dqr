class CreateSensorLogs < ActiveRecord::Migration
  def change
    create_table :sensor_logs do |t|
      t.datetime :date
      t.references :device_module, index: true, foreign_key: true
    end
  end
end
