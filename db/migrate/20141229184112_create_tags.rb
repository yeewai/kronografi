class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :content
      t.text :description
      t.string :slug

      t.timestamps null: false
    end
    
    create_table :events_tags, id: false do |t|
      t.belongs_to :event, index: true
      t.belongs_to :tag, index: true
    end
  end
end
