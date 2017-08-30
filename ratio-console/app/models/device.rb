class Device < ActiveRecord::Base
  belongs_to :device_type
  belongs_to :ambience
  has_many :device_modules
end
