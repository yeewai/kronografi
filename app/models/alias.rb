class Alias < ActiveRecord::Base
  belongs_to :character
  belongs_to :world
  
  after_save :link_events
  
  private
  def link_events
    Event.where("summary like ? OR details like ?", "%@[#{self.name}]%", "%@[#{self.name}]%").each(&:save!)
    self.character.events.each(&:save!) if self.character
  end
end
