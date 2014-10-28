module ApplicationHelper
  
  def core_props_for_react
    {me: current_user}.to_json.html_safe
  end
  
end
