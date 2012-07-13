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
end
