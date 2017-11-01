class AddDetectionPendingToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :detection_pending, :boolean, null:false, default: false
  end
end
