class AddSceneToDevice < ActiveRecord::Migration
  def change
    add_reference :devices, :scene, foreign_key:true
  end
end
