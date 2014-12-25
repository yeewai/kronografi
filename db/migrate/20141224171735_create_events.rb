class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :summary
      t.text :details
      t.date :happened_on

      t.timestamps null: false
    end
  end
end
