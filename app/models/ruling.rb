class Ruling < ActiveRecord::Base
  belongs_to :user
  belongs_to :world
  
  before_create :find_user
  
  private
  def find_user
    self.user = User.find_by_email self.email
  end
end
