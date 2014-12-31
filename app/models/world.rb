class World < ActiveRecord::Base
  belongs_to :user
  has_many :characters
  has_many :aliases
  has_many :events
  has_many :tags
  before_create :generate_token
  
  def to_param
    self.token
  end
  
  private
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless World.exists?(token: random_token)
    end
  end
end
