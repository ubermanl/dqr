class AddDefaultPreferences < ActiveRecord::Migration
  def self.up
    ConsolePreference.delete_all
    ConsolePreference.create(graphic_interval: 10, graphic_refresh_interval: 60)
  end
  def self.down
  end
end
