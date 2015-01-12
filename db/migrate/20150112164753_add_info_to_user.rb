class AddInfoToUser < ActiveRecord::Migration
  def self.up
    add_attachment :users, :avatar
    add_column :users, :name, :string
  end

  def self.down
    remove_attachment :characters, :avatar
    remove_column :users, :name
  end
end
