class AdjustAdminUser < ActiveRecord::Migration
  def change
    execute 'update users set active = 1, role = 0 where login=\'admin\';'
  end
end
