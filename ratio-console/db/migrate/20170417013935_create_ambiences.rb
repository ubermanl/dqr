class CreateAmbiences < ActiveRecord::Migration
  def change
    create_table :ambiences do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
