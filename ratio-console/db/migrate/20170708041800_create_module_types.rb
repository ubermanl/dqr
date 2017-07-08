class CreateModuleTypes < ActiveRecord::Migration
  def change
    create_table :module_types do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
