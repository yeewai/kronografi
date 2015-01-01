class Character < ActiveRecord::Base
  belongs_to :world
  has_many :aliases, :dependent => :delete_all
  has_and_belongs_to_many :events
  
  has_attached_file :avatar, :default_url => "/images/avatar.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  before_save :generate_slug
  after_save :link_events
  
  
  def nicknames=(str)
    a_arr = str.squish.split(",")
    
    a_arr.each do |a|
      self.aliases << Alias.find_or_create_by(name: a.squish, world_id: self.world_id)
    end
  end
  
  def nicknames
    ''
    #self.aliases.pluck("name").join(", ")
  end
  
  private
  def generate_slug
    self.slug = Tag.sanitize(self.name)
  end
  
  def link_events
    (Event.where("summary like ? OR details like ?", "%@[#{self.name}]%", "%@[#{self.name}]%") + self.events).each(&:save!)
  end
end
