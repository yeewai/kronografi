class Alias < ActiveRecord::Base
  belongs_to :concept
  belongs_to :world
  
  after_save :link_events
  
  private
  def link_events
    Event.where("summary like ? OR details like ?", "%@[#{self.name}]%", "%@[#{self.name}]%").each(&:save!)
    self.concept.events.each(&:save!) if self.concept
  end
end
