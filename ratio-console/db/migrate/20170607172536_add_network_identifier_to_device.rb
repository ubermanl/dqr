class AddNetworkIdentifierToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :network_identifier, :string
  end
end
