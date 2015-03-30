class RenameCharactertoConcept < ActiveRecord::Migration
  def change
    rename_table :characters, :concepts
    rename_table :characters_events, :concepts_events
    rename_column :concepts_events, :character_id, :concept_id
    rename_column :aliases, :character_id, :concept_id
  end
end
