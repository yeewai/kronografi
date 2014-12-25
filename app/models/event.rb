class Event < ActiveRecord::Base
  #scope :for_year_and_month, lambda {|y, m| where("happened_on >= ? and happened_on <= ?", "#{sprintf("%.4d", y)}-#{sprintf("%02d", m)}-01", "#{sprintf("%.4d", y)}-#{sprintf("%02d", m + 2)}-31")}

  before_save :cache_happened
  
  
  def self.generate_key(year, month)
    "y#{("n" if year < 0)}#{year.abs}m#{(month-1)/3}"
  end
  private
  def cache_happened
    self.happened_key = Event.generate_key(happened_on.year, happened_on.month)
  end
end
