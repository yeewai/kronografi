class CreateRulings < ActiveRecord::Migration
  def change
    create_table :rulings do |t|
      t.integer :user_id
      t.integer :world_id
      t.string :role

      t.timestamps null: false
    end
  end
end
