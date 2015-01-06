class AddKindToEvent < ActiveRecord::Migration
  def change
    add_column :events, :kind, :string, null: false, default: "regular"
  end
end
