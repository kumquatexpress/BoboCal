class RegistrationsController < Devise::RegistrationsController
  prepend_view_path "app/views/devise"
  
  def create
    super
    user = User.where(:email => params[:user]['email']).first
    user.set_default_picture
  end
  
  def update
    super
  end
  
  def cancel
    super
  end
  
  def new
    super
  end
  
  def edit
    super
  end
  
  def update
    super
  end
  
  def destroy
    super
  end
end