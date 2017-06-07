class ProgramCondition < ActiveRecord::Base
  belongs_to :program
  belongs_to :device_sensor
end
