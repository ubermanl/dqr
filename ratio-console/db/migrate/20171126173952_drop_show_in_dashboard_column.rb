class DropShowInDashboardColumn < ActiveRecord::Migration
  def change
    remove_column :device_modules, :show_in_dashboard
  end
end
