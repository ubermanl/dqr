class Device < ActiveRecord::Base
  belongs_to :ambience
  has_many :modules, class_name:'DeviceModule', dependent: :destroy
  has_many :events, class_name:'DeviceEvent'
end
