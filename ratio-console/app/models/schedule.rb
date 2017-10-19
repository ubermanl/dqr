class Schedule < ActiveRecord::Base
  has_many :schedule_days
  
  validates :description, presence: true
end
