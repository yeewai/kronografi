class AddAvatarToCharacter < ActiveRecord::Migration
  def self.up
    add_attachment :characters, :avatar
  end

  def self.down
    remove_attachment :characters, :avatar
  end
end
