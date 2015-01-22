module RulingsHelper
  def translate_rulingrole(role)
    case role
    when "admin"
      "Can edit world settings"
    when "write"
      "Can contribute content"
    when "view"
      "Can view"
    end
  end
end
