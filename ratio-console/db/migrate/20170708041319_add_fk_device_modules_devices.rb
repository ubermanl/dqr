class AddFkDeviceModulesDevices < ActiveRecord::Migration
  def change
    add_foreign_key :device_modules, :devices
  end
end
