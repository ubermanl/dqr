class AddGraphScaleToSensorType < ActiveRecord::Migration
  def change
    add_column :sensor_types, :graphic_scale, :string
  end
end
