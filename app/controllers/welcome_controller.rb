class WelcomeController < ApplicationController
  def index
    redirect_to worlds_path if user_signed_in?
  end
  
  def help
  end
end
