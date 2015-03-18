class SessionsController < Devise::SessionsController 
  layout false 

  def after_sign_in_path_for(scope)
    if scope.is_a?(User)
      my_home_path(scope)
    else
      super
    end
  end
  
end
