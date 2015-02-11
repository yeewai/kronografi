class World < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  has_many :rulings
  has_many :users, through: :rulings
  has_many :characters
  has_many :aliases
  has_many :events
  has_many :tags
  before_create :generate_token
  after_create :set_creator_ruling
  
  def to_param
    self.token
  end
  
  def set_creator_ruling
    self.rulings.create user_id: self.user_id, role: "admin", email: self.user.email
  end
  
  def can_be_edited_by(user)
    user && (r = user.rulings.find_by_world_id(self.id)) && ["admin", "write"].include?(r.role)
  end
  
  private
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless World.exists?(token: random_token)
    end
  end
  
  
end
