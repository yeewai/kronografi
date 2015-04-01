class CreateGars < ActiveRecord::Migration
  def change
    create_table :gars do |t|
      t.string :name
      t.text :value
      t.text :url
      t.string :ipaddress
      t.string :user_agent
      t.text :referer

      t.timestamps null: false
    end
  end
end
