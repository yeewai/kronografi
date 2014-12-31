class Tag < ActiveRecord::Base
  belongs_to :world
  has_and_belongs_to_many :events
  
  before_save :generate_slug
  
  def self.sanitize(str)
    s = str.dup
    
    #blow away apostrophes
    s.gsub! /['`]/,""

    # @ --> at, and & --> and
    s.gsub! /\s*@\s*/, " at "
    s.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore or periods with underscore
    s.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '_'  

    #convert double underscores to single
    s.gsub! /_+/,"_"

    #strip off leading/trailing underscore
    s.gsub! /\A[_\.]+|[_\.]+\z/,""

    s
  end
  
  private
  def generate_slug
    self.slug = Tag.sanitize(self.content)
  end
end
