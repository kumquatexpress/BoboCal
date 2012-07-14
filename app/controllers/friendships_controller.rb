class FriendshipsController < ApplicationController
  before_filter :authenticate_user!
    
  def index
    @friendships = Friendship.all
  end
  
  #GET /create
  def create
    first_user = current_user
    second_user = User.find(params[:second_id])
    @friendship = Friendship.new
    @friendship.make_new(first_user, second_user, false)
    
    respond_to do |format|
      format.html { redirect_to users_list_friendships_path, :notice => 'Friend Request Sent' }
      format.json { head :no_content }
    end
    
  end
  
  #GET /approve/1
  def approve
    @friendship = Friendship.find(params[:id])
    friend = User.find(@friendship.friend_id)
    
    @friendship.approve
    
        
    respond_to do |format|
      format.html { redirect_to friend_requests_friendships_path, :notice => 'You are now friends with' }
      format.json { head :no_content }
    end
  end
  
  def ignore
    @friendship = Friendship.find(params[:id])
    @friendship.ignore
    
    respond_to do |format|
      format.html { redirect_to friend_requests_friendships_path, :notice => 'You are now friends with' }
      format.json { head :no_content }
    end
  end
  
  #DELETE /friendships/1
  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy   
    
    respond_to do |format|
      format.html { redirect_to friendships_path, :method => :get }
      format.json { head :no_content }
    end
  end
  
  def show
    @friendships = Friendship.all
  end
  
  #GET /friend_requests
  def friend_requests
    user = current_user
    @friendships = user.requested_friends
    @friends = Array.new
    
    
    counter = 0
    @friendships.each do |friend|
      temp = Array.new
      temp[0] = User.find(friend.id)
      temp[1] = Friendship.where(:friend_id => user.id, :user_id => friend.id).first
      
      @friends[counter] = temp
      counter += 1
    end
    
    respond_to do |format|
      format.html
      format.json {render :json => @friends}
    end
    @friends
    
    
  end
  
  def users_list
    @previous_page = true
    @next_page = true
    @name = params[:name]
    
    if @name
      users = User.search(@name.downcase)
    else
      users = []
    end
    
    totalnum = users.count/25
    if params[:page].to_i() > 0
      @page_num = params[:page].to_i()
    else
      @page_num = 0
      @previous_page = false
    end

    if @page_num >= totalnum
      @page_num = totalnum
      @next_page = false
    end
    
    if users.first
      @users = users[@page_num*25..(@page_num+1)*24] 
    else
      @users = 35
    end
    
    unless params[:name]
      @users = []
    end
    
    respond_to do |format|
      format.html
      format.json { render :json => @users }
    end
    
  end
  
end