class User < ActiveRecord::Base
    # authenticacion con authlogic
  acts_as_authentic do |c|
    c.login_field = :login
  end
end
