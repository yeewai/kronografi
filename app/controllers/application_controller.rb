class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def authenticate_world(world_token, mode='read')
    @world = World.find_by_token world_token
    if !@world || !user_signed_in?
      redirect_to worlds_path, notice: "Sorry. We couldn't find that world and its related content."
    elsif mode == "read"
      redirect_to worlds_path, notice: "Sorry. We couldn't find that world and its related content." if !current_user.worlds.include?(@world)
    elsif mode == "write"
      redirect_to worlds_path, notice: "Sorry. You don't have permission to do that." if !((r = current_user.rulings.find_by_world_id(@world.id)) && ["admin", "write"].include?(r.role))
    end
  end
  

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << [:name, :avatar]
  end
end
