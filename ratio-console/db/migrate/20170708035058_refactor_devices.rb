class RefactorDevices < ActiveRecord::Migration
  def change
    remove_reference :devices, :device_type, foreign_key: true
    drop_table :device_types
  end
end
