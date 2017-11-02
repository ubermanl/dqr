class AddNameToModule < ActiveRecord::Migration
  def change
    add_column :device_modules, :name, :string
  end
end
