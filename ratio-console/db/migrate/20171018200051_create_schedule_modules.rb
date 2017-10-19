class CreateScheduleModules < ActiveRecord::Migration
  def change
    create_table :schedule_modules do |t|
      t.references :device_module, index: true, foreign_key: true
      t.integer :desired_status, null: false
      t.references :schedule, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
