class ChangeEventtoDateTime < ActiveRecord::Migration
  def change
    change_column :events, :happened_on,  :datetime
  end
end
