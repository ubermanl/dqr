class CreateProgramConditions < ActiveRecord::Migration
  def change
    create_table :program_conditions do |t|
      t.references :program, index: true, foreign_key: true, null: false
      t.references :device_sensor, index: true, foreign_key: true, null: false
      t.decimal :min_value, precision: 10, scale:4
      t.decimal :max_value, precision: 10, scale:4
      t.timestamps null: false
    end
  end
end
