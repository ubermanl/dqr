class AddPreviousStateToModule < ActiveRecord::Migration
  def change
    add_column :device_modules, :previous_state, :integer, null:false, default: 0
    add_column :schedules, :is_running, :boolean, null: false, default: false
  end
end
