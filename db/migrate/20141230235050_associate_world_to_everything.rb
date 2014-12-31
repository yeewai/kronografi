class AssociateWorldToEverything < ActiveRecord::Migration
  def change
    add_column :events, :world_id, :integer, :null => false, :default => 1
    add_index :events, :world_id
    add_column :characters, :world_id, :integer, :null => false, :default => 1
    add_index :characters, :world_id
    add_column :aliases, :world_id, :integer, :null => false, :default => 1
    add_index :aliases, :world_id
    add_column :tags, :world_id, :integer, :null => false, :default => 1
    add_index :tags, :world_id
  end
end
