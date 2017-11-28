class User < ActiveRecord::Base
  self.primary_key = 'login'
    # authenticacion con authlogic
  acts_as_authentic do |c|
    c.login_field = :login
  end
  
  has_many :user_pinned_modules, primary_key: :login, foreign_key: :login, dependent: :destroy
  has_many :device_modules, through: :user_pinned_modules
  
  validates :login, uniqueness: true, presence: true
  validate :at_least_one_admin
  def admin?
    role == 0
  end
  
  def at_least_one_admin
    if User.where(:role => 0, :active => 1).where.not(:login => self.login).none? && !admin?
      errors.add(:base,'There must be at least one active admin account')
    end
  end
end
