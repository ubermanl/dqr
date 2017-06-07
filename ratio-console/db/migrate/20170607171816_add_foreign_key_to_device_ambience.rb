class AddForeignKeyToDeviceAmbience < ActiveRecord::Migration
  def change
    add_foreign_key :devices, :ambiences
  end
end
