class Event < ActiveRecord::Base
  has_and_belongs_to_many :tags
  before_save :cache_happened
  
  def set_tags=(str)
    self.tags.clear
    tags_arr = str.squish.split(",")
    
    tags_arr.each do |t|
      self.tags << Tag.find_or_create_by(content: t)
    end
  end
  
  def set_tags
    self.tags.pluck("content").join(", ")
  end
  
  def self.generate_key(year, month)
    "y#{("n" if year < 0)}#{year.abs}m#{(month-1)/3}"
  end
  
  private
  def cache_happened
    self.happened_key = Event.generate_key(happened_on.year, happened_on.month)
  end
end
