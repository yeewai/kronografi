class AddPublicToWorld < ActiveRecord::Migration
  def change
    add_column :worlds, :is_public, :boolean, default: false
  end
end
