class CreateModuleStates < ActiveRecord::Migration
  def self.up
    create_table :module_states,id:false do |t|
      t.integer :id, null: false
      t.string :name, null: false 
    end
    execute 'alter table module_states add primary key(id)'
  end
  def self.down
    drop_table :module_states
  end
end
