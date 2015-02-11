module ApplicationHelper
  def app_name
    "Kronografi"
  end
  
  def can_do(action, world)
    if current_user && (r = current_user.rulings.find_by_world_id(world.id))
      case action
      when "view"
        true
      when "write"
        ["admin", "write"].include?(r.role)
      when "admin"
        r.role == "admin"
      end
    else
      false
    end
  end
end
