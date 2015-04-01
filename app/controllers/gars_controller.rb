class GarsController < ApplicationController
  before_action :authenticate_user!
  def index
    @usersize = User.all.size
    @eventsize = Event.all.size
    @conceptsize = Concept.all.size
    
    @visits = Gar.where(name: 'visit').reverse
  end
end
