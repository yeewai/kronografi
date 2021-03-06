class Concept < ActiveRecord::Base
  belongs_to :world
  belongs_to :user
  has_many :aliases, :dependent => :delete_all
  has_and_belongs_to_many :events
  
  has_paper_trail :on => [:update, :destroy]#, :skip => [:name]
  
  has_attached_file :avatar, :default_url => "/images/avatar.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  before_save :generate_slug
  after_save :link_events
  after_create :update_aliases
  
  
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
  
  def self.destroyed_models(world)
    chars = PaperTrail::Version.where(event: "destroy", item_type: "Concept").where("object LIKE ?", "%world_id: #{world.id}%")
    chars.map(&:reify).reverse if chars.any?
  end
  
  private
  def generate_slug
    self.slug = Tag.sanitize(self.name)
  end
  
  def link_events
    (Event.where("summary like ? OR details like ?", "%@[#{self.name}]%", "%@[#{self.name}]%") + self.events).each(&:save!)
  end
  
  def update_aliases
    self.aliases.each do |e|
      e.update_attributes world_id: self.world.id
    end
  end
end
