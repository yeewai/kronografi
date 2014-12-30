class CreateAliases < ActiveRecord::Migration
  def change
    create_table :aliases do |t|
      t.string :name
      t.belongs_to :character, index: true

      t.timestamps null: false
    end
  end
end
