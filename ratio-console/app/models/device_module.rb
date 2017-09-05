class DeviceModule < ActiveRecord::Base
  belongs_to :device
  belongs_to :module_type
end
