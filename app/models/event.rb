class Event < ActiveRecord::Base
  scope :for_year_and_month, lambda {|y, m| where("happened_on >= ? and happened_on <= ?", "#{sprintf("%.4d", y)}-#{sprintf("%02d", m)}-01", "#{sprintf("%.4d", y)}-#{sprintf("%02d", m + 2)}-31")}
end
