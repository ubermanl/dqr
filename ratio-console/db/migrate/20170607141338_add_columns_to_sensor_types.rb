class AddColumnsToSensorTypes < ActiveRecord::Migration
  def change
    add_column :sensor_types, :max_value, :decimal, precision: 10, scale:4
    add_column :sensor_types, :min_value, :decimal, precision:10, scale:4
    add_column :sensor_types, :inactive, :boolean
  end
end
