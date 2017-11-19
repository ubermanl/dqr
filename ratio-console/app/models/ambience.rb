class Ambience < ActiveRecord::Base
  has_many :devices, dependent: :restrict_with_exception
  
  validates :name, presence: true, uniqueness: true, length: { maximum: 40 }
end
