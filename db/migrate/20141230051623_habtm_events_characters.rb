class HabtmEventsCharacters < ActiveRecord::Migration
  def change
    create_table :characters_events, id: false do |t|
      t.belongs_to :character, index: true
      t.belongs_to :event, index: true
    end
  end
end
