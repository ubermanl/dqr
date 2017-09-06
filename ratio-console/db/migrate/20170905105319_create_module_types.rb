class CreateModuleTypes < ActiveRecord::Migration
  def self.up
    create_table :module_types, id:false do |t|
      t.integer :id, null: false
      t.string :name
      t.timestamps null: false
    end
    
    execute 'alter table module_types add primary key(id)'
  end
  def self.down
    drop_table :module_types
  end
end
