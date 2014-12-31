class AssociateWorldUser < ActiveRecord::Migration
  def change
    add_column :worlds, :user_id, :integer
  end
end
