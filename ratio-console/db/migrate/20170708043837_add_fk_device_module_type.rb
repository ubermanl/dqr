class AddFkDeviceModuleType < ActiveRecord::Migration
  def change
    add_foreign_key :device_modules, :module_types
  end
end
