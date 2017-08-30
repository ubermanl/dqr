class DeviceModule < ActiveRecord::Base
  belongs_to :device
  belongs_to :module_type
  has_many :sensors
end
