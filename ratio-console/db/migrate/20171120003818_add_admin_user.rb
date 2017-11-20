class AddAdminUser < ActiveRecord::Migration
  def change
    admin = User.new login: 'admin', name:'Ratio Admin', mail:'ratio@drq.local'
    admin.password = 'dqrrules'
    admin.password_confirmation = 'dqrrules'
    admin.save
  end
end
