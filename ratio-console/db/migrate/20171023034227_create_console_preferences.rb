class CreateConsolePreferences < ActiveRecord::Migration
  def change
    create_table :console_preferences, id: false do |t|
      t.integer :graphic_refresh_interval
      t.integer :graphic_interval
      t.timestamps null: false
    end
  end
end
