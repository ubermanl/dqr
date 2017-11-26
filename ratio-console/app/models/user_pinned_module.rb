class UserPinnedModule < ActiveRecord::Base
  belongs_to :device_module
  belongs_to :user
end
