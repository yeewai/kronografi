class WelcomeController < ApplicationController
  def index
    redirect_to worlds_path if user_signed_in?
    @exampleworld = World.find_by_name "Krono's World"
  end
  
  def help
  end
end
