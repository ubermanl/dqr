class Ambience < ActiveRecord::Base
  validates :name, uniqueness: true
end
