class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.references :sensor_type, foreign_key: true, null:false
      t.references :device, foreign_key: true, null: false
      t.timestamps null: false
    end
  end
end
