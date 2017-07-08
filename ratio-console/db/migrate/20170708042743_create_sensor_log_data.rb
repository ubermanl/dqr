class CreateSensorLogData < ActiveRecord::Migration
  def change
    create_table :sensor_log_data, id:false do |t|
      t.references :sensor_log, index: true, foreign_key: true
      t.references :sensor, index: true, foreign_key: true
      t.decimal :value
    end
  end
end
