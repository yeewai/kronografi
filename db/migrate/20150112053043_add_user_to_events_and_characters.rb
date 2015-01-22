class AddUserToEventsAndCharacters < ActiveRecord::Migration
  def change
    add_column :events, :user_id, :integer
    add_column :characters, :user_id, :integer
  end
end
