class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def authenticate_world(world_token)
    @world = World.find_by_token world_token
    redirect_to worlds_path, notice: "Sorry. We couldn't find that world and its related content." if !@world || !(user_signed_in? && current_user.worlds.include?(@world))
  end
end
