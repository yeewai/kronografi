class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :gar_watches_you
  
  def authenticate_world(world_token, mode='read')
    @world = World.find_by_token world_token
    if !@world 
      redirect_to worlds_path, notice: "Sorry. We couldn't find that world and its related content."
    else
      case mode
      when "read"
        redirect_to worlds_path, notice: "Sorry. We couldn't find that world and its related content." if !@world.is_public && !(user_signed_in? && current_user.worlds.include?(@world))
      when "write"
        redirect_to worlds_path, notice: "Sorry. You don't have permission to do that." if !user_signed_in? || !((r = current_user.rulings.find_by_world_id(@world.id)) && ["admin", "write"].include?(r.role))
      when "admin"
        redirect_to worlds_path, notice: "Sorry. You don't have permission to do that." if !user_signed_in? || !((r = current_user.rulings.find_by_world_id(@world.id)) && r.role == "admin")
      end
    end
  end
  
  def gar_watches_you(action='visit', val=nil)
    m = Gar.create :name => action, :value=>val, :ipaddress => request.remote_ip, :url => request.fullpath, :user_agent => request.user_agent, referer: request.referer unless (request.referer.nil? || request.referer.include?(request.host))
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << [:name, :avatar]
  end
end
