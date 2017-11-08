class Device < ActiveRecord::Base
  belongs_to :ambience
  has_many :modules, class_name:'DeviceModule', dependent: :destroy
  has_many :events, class_name:'DeviceEvent'
  
  validates :id, uniqueness: true, presence: true
  validates :name, uniqueness: true, presence: true
  validates :ambience_id, presence: true
  
  accepts_nested_attributes_for :modules
  
  after_commit :mark_detected, on: :update
  
  
  def mark_detected
    if self.detection_pending
      update_column(:detection_pending, false)
    end
  end
end
