class AddDescriptionToDeviceTypes < ActiveRecord::Migration
  def change
    add_column :device_types, :description, :string
    add_column :device_types, :inactive, :boolean
  end
end
