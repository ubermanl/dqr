class UniqueIndexOnScheduleModules < ActiveRecord::Migration
  def change
    add_index :schedule_modules, [:device_module_id,:schedule_id], unique: true
  end
end
