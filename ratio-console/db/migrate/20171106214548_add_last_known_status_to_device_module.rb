class AddLastKnownStatusToDeviceModule < ActiveRecord::Migration
  def change
    add_column :device_modules, :last_known_status, :integer, null: false, default: 0
    add_column :device_modules, :last_known_status_datetime, :timestamp
  end
end
