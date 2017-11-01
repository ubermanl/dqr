class AddPinToDashboardToDeviceModule < ActiveRecord::Migration
  def change
    add_column :device_modules, :show_in_dashboard, :boolean, null:false, default: false
  end
end
