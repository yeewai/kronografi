class AddHappenedKey < ActiveRecord::Migration
  def change
    add_column :events, :happened_key, :string
  end
end
