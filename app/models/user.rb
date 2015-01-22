class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
         
  has_many :rulings
  has_many :worlds, through: :rulings
  has_many :createdworlds, class_name: "World", foreign_key: "user_id"
  has_many :characters
  has_many :events
  
  has_attached_file :avatar, :default_url => "/images/avatar.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  after_create :set_rulings
  
  private
  def set_rulings
    Ruling.where(email: self.email).each do |r|
      r.user = self
      r.save
    end
  end
end
