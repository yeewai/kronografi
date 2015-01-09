class AddSettingsToWorld < ActiveRecord::Migration
  def change
    add_column :worlds, :scale, :string, default: "years"
    add_column :worlds, :is_absolute, :boolean, default: true
  end
end
