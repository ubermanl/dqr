class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.references :object, polymorphic: true, index: true
      t.integer :priority, null: false
      t.boolean :desired_state
      t.string :description
      t.string :start_time
      t.string :stop_time
      t.boolean :inactive
      t.timestamps null: false
    end
  end
end
