class AddConfigToSensorType < ActiveRecord::Migration
  def change
    add_column :sensor_types, :graph_min_value, :string, null: false, default: ''
    add_column :sensor_types, :graph_max_value, :string, null: false , default: ''
    add_column :sensor_types, :graph_step, :string, null: false, default: ''
    add_column :sensor_types, :graph_scale_type, :string, null: false, default: ''
    add_column :sensor_types, :graph_description, :text,limit: 500, null: false
    add_column :sensor_types, :graph_scale_labels, :string, null: false, default: ''
  end
end
