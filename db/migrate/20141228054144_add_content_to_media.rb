class AddContentToMedia < ActiveRecord::Migration
  def self.up
      add_attachment :media, :content
    end

    def self.down
      remove_attachment :media, :content
    end
end
