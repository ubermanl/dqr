class DropSensorEvents < ActiveRecord::Migration
  def change
    drop_table :sensor_events
  end
end
