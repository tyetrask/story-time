module NavigationHelper
  
  def active_link_class?(controller_name_match)
    return 'active' if controller_name_match == controller_name
    ''
  end
  
end
