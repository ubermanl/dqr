class AddAmbienceToDevice < ActiveRecord::Migration
  def change
    add_reference :devices, :ambience
  end
end
