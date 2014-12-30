module EventsHelper
  def year_range 
    if @start_event
      start = [@start_event.happened_on.year-5, Event.order(:happened_on).first.happened_on.year].min
      finish = [@start_event.happened_on.year+5, Event.order(:happened_on).last.happened_on.year].max
      start..finish
    else
      []
    end
  end
  
  def format_date(y,m=nil,d=nil)
    if y.is_a?(String) || y.is_a?(Integer)
      "#{sprintf("%.4d", y)}-#{sprintf("%02d", m)}-#{sprintf("%02d", d)} 12:00"
    else
      y.strftime("%Y-%m-%d %H:%M")
    end
  end
  
  def generate_link_for(char)
    unless c = Character.find_by_name(char)
      n = Alias.find_by_name char 
      c = n.character if n
    end
    
    if c
      link_to char, c, class: "valid"
    else
      link_to char, new_character_path(name: char), class: "invalid"
    end
  end
  
  def replace_chars(text)
    text.gsub(CHAR_PATTERN){ generate_link_for($1)}
  end
end
