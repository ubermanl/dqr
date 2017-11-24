class Ambience < ActiveRecord::Base
  has_many :devices, dependent: :restrict_with_exception
  
  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }
  
  before_validation :sanitize
  
  def sanitize
    self.name = self.name.strip if self.name.present?
  end
end
