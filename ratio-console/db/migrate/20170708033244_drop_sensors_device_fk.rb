class DropSensorsDeviceFk < ActiveRecord::Migration
  def change
    remove_foreign_key :sensors, :devices
  end
end
