class AddKindToConcept < ActiveRecord::Migration
  def up
    add_column :concepts, :kind, :string, default: "misc"
    Concept.find_each{|c| c.update_attributes(kind: "character")}
  end
  
  def down
    remove_column :concepts, :kind
  end
end
