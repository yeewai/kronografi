class Character < ActiveRecord::Base
  has_many :aliases, :dependent => :delete_all
  has_and_belongs_to_many :events
  
  has_attached_file :avatar, :default_url => "/images/avatar.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  before_save :generate_slug
  after_save :link_events
  
  
  def nicknames=(str)
    self.aliases.clear
    a_arr = str.squish.split(",")
    
    a_arr.each do |a|
      self.aliases << Alias.find_or_create_by(name: a.squish)
    end
  end
  
  def nicknames
    self.aliases.pluck("name").join(", ")
  end
  
  private
  def generate_slug
    self.slug = Tag.sanitize(self.name)
  end
  
  def link_events
    event_ids = self.events.pluck(:id)
    
    self.events.each(&:save!)
    
    if self.name_changed?
      Event.where("summary like ? OR details like ?", "%@[#{self.name}]%", "%@[#{self.name}]%").where.not(id: event_ids).each(&:save!)
    end
    
    q = []
    names = []
    self.aliases.each do |a|
      q.push "summary like ? OR details like ?"
      names += ["%@[#{a.name}]%", "%@[#{a.name}]%"]
    end
    
    Event.where(q.join(" OR "), *names).where.not(id: event_ids).each(&:save!)
  end
end
