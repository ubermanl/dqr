class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :description
      t.boolean :inactive
      t.boolean :enabled

      t.timestamps null: false
    end
  end
end
