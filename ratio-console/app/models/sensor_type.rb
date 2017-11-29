class SensorType < ActiveRecord::Base
  has_many :module_sensors, dependent: :restrict_with_exception
  
  validates :id, presence: true, uniqueness: true, numericality: { greater_than: 0, less_than: 10 }
  validates :name, presence: true, uniqueness: true
  validates :graph_min_value, presence: true, numericality: true
  validates :graph_max_value, presence: true, numericality: true
  validates :graph_step, presence: true, numericality: true
  
  validate :changed_sensor_id
  
  def changed_sensor_id
    if persisted? && id != id_was
      errors.add(:id, 'Cant be changed')
    end
  end
end
