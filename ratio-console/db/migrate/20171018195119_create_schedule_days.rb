class CreateScheduleDays < ActiveRecord::Migration
  def change
    create_table :schedule_days do |t|
      t.references :schedule, index: true, foreign_key: true
      t.integer :day
      t.string :start_hour, limit:7, null:false 
      t.string :end_hour, limit:7, null:false 
      t.timestamps null: false
    end
  end
end
