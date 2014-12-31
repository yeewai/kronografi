class Alias < ActiveRecord::Base
  belongs_to :character
  belongs_to :world
end
