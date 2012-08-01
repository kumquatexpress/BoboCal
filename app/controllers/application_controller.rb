class ApplicationController < ActionController::Base
  protect_from_forgery
  def show
    if not user_signed_in?
      redirect_to new_user_session_path
    end
  end
  
  def current_calendar
    Calendar.find(session[:calendar_id])
  end
  
  def after_sign_in_path_for(resource)
    if current_user.sign_in_count == 0
      alternatives_path
    end
    calendars_path
  end
  
  def after_sign_up_path_for(resource)
  if current_user.sign_in_count == 0
      alternatives_path
    end
    calendars_path
  end


end
