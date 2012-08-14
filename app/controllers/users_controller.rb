class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def profile
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to 
    end
  end
  
  def friends
    @users = []
    
    if params[:name]
      @name = params[:name]
      unfiltered_friends = User.search(@name.downcase)
    else 
      unfiltered_friends = current_user.friends
    end
    friends = Array.new
    
    unfiltered_friends.each do |f|
      if current_user.friends.include?(f)
        friends.push(f)
      end
    end
    
    if params[:event]
      @event = Event.find(params[:event])
    end
    
    @previous_page = true
    @next_page = true
    
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