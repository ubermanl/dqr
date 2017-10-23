class ConsolePreference < ActiveRecord::Base
  validates :graphic_refresh_interval, presence: true, numericality: { grater_than: 10 }
  validates :graphic_interval, presence: true, numericality: { greater_than: 5}
end
