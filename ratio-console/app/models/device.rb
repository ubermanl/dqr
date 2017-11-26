class Device < ActiveRecord::Base
  belongs_to :ambience
  has_many :modules, class_name:'DeviceModule', dependent: :destroy
  has_many :events, class_name:'DeviceEvent'

  
  validates :id, uniqueness: true, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 255 }
  validates :name, uniqueness: true, presence: true
  validates :ambience_id, presence: true
  
  before_validation :sanitize
  
  accepts_nested_attributes_for :modules
  
  after_commit :mark_detected, on: :update
  
  
  def mark_detected
    if self.detection_pending
      update_column(:detection_pending, false)
    end
  end
  
  def sanitize
    self.name = self.name.strip if self.name.present?
  end
end
