class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def after_sign_in_path_for(resource)
    if current_user.sign_in_count < 2
      alternatives_path
    else
      calendars_path
    end
  end
  
  def after_sign_up_path_for(resource)
    if current_user.sign_in_count < 2
        alternatives_path
    else
      calendars_path
    end
  end

end
