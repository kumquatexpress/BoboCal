class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def profile
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to 
    end
  end
  
  def friends
    @previous_page = true
    @next_page = true
    
    @user = current_user
    friends = @user.friends
    @totalnum = friends.count/25
    
    if params[:page].to_i() > 0
      @page_num = params[:page].to_i()
    else
      @page_num = 0
      @previous_page = false
    end
        
    if @page_num >= @totalnum
      @page_num = @totalnum
      @next_page = false
    end
    
    if friends.first
      @friends = friends[@page_num*25..(@page_num+1)*24] 
    else
      @friends = []
    end
    
  end
  

end