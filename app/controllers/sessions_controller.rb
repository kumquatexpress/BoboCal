class SessionsController < Devise::SessionsController
    prepend_view_path "app/views/devise"
  
  def create
    super    
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