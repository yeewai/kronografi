class Event < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :characters
  before_save :cache_data
  
  
  def set_happened=(s)
    if d = DateTime.parse(s)
      self.happened_on = d 
    end
  end
   
  def set_happened
    happened_on.strftime("%d/%m/%Y %I:%M%p") if happened_on
  end
  
  def set_tags=(str)
    self.tags.clear
    tags_arr = str.squish.split(",")
    
    tags_arr.each do |t|
      self.tags << Tag.find_or_create_by(content: t.squish)
    end
  end
  
  def set_tags
    self.tags.pluck("content").join(", ")
  end
  
  def self.generate_key(year, month)
    "y#{("n" if year < 0)}#{year.abs}m#{(month-1)/3}"
  end
  
  private
  def cache_data
    self.happened_key = Event.generate_key(happened_on.year, happened_on.month)
    
    if summary && details
      self.characters.clear
      (summary.scan(CHAR_PATTERN) + details.scan(CHAR_PATTERN)).flatten.each do |name|
        unless char = Character.find_by_name(name)
          n = Alias.find_by_name name
          char = n.character if n
        end
        self.characters << char if char && !self.characters.include?(char)
      end
    end
  end
end

CHAR_PATTERN = /@\[(.*?)\]/