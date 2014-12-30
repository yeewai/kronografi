class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.integer :age

      t.timestamps null: false
    end
  end
end
