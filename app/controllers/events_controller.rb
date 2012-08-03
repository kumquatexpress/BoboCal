class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  before_filter :authenticate_user!, :check_correct_user!
  
  def check_correct_user!
    if params[:id]
      @event = Event.find(params[:id])
      unless @event.invited_users.include?(current_user) || @event.user_id == current_user.id
        flash[:warning] = "You're not invited to that event :("
        redirect_to events_path
      end
    end
  end
  
  def index
    if user_signed_in?
      @my_events = Event.where(:user_id => 
      current_user.id).order("start_at")
      @invited_events = Array.new
      
      current_user.invited_events.each do |event|
        @invited_events.push(event)
      end
      
      if @invited_events != []
        @my_events.each do |event|
          @invited_events.delete(event)
        end
      end
    else
      @events = Event.where(:user_id =>
      nil)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    #for calendar display
    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month, :conditions => ['user_id = ?', current_user.id])
    
    
    @event = Event.find(params[:id])
    @calendar = Calendar.find(@event.calendar_ids)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event }
    end
  end
  
  def invite_friend  
    @name = params[:name]

    if params[:name]
      friends = User.search(@name.downcase)
    else 
      friends = current_user.friends
    end
    
    if params[:event] != nil
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
    
    if params[:path] == "true"
      Event.add_invited_user(params[:event], params[:user])
    elsif params[:path] == "false"
      Event.delete_invited_user(params[:event], params[:user])
    elsif params[:path] == "admin add"
      Event.add_admin_user(params[:event], params[:user])
    elsif params[:path] == "admin remove"
      Event.delete_admin_user(params[:event], params[:user])
    end
    
    respond_to do |format|
      format.json {render :json => @event.invited_users}
      format.js { render :layout => false}
    end
        
  end

  # GET /events/new
  # GET /events/new.json
  def new
    #for calendar display
    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month, :conditions => ['user_id = ?', current_user.id])
    
    
    @calendar = Calendar.all
    @event = Event.new(params[:event])
    @event.user_id = current_user.id
    @event.invited_users.push(current_user)
    @event.save
    
    Event.save_to_google_calendar(@event.id, current_user.id)
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @event }
    end
  end

  # GET /events/1/edit
  def edit
    #for calendar display
    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month, :conditions => ['user_id = ?', current_user.id])
    
    
    @event = Event.find(params[:id])
    
    @calendar = Calendar.where(:user_id => 
    current_user.id)
  end

  # POST /events
  # POST /events.json
  def create
    @calendar = Calendar.all
    @event = Event.new(params[:event])
    @event.user_id = current_user.id
    
      respond_to do |format|
          if @event.save
          
            #call google api client to save event
            Event.save_to_google_calendar(@event.id, current_user.id)
            
            format.html { redirect_to @event, :notice => 'Calendar event was successfully created.' }
            format.json { render :json => @event, :status => :created, :location => @event }
          else
            format.html { redirect_to :notice => 'Conflicting Event Times'}
            format.json { render :json => @event.errors, :status => :unprocessable_entity }
          end
            format.html { redirect_to :notice => 'Conflicting Event Times'}
            format.json { render :json => @event.errors, :status => :unprocessable_entity }
     end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])
    @calendar = Calendar.where(:user_id => 
    current_user.id)
    unless @event.user_id
      @event.user_id = current_user.id  
    end
    
    respond_to do |format|
      if @event.update_attributes(params[:event])
          Event.update_google_calendar(@event.id, current_user.id)
      
        format.html { redirect_to @event, :notice => 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    Event.delete_from_google_calendar(@event.id, current_user.id)
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
  
  #GET /
  def show_calendar
    respond_to do |format|
       format.js { render :layout => false}
    end
  end
  
  # POST /mobileCreate
  def mobileCreate
    event = Event.new
    event.calendar = params[:calendars]
    event.startTime = params[:startTime]
    event.endTime = params[:endTime]
    event.save
        respond_to do |format|
        if @event.fits?
          if @event.save
            format.html { redirect_to @event, :notice => 'Calendar event was successfully created.' }
            format.json { render :json => @event, :status => :created, :location => @event }
          else
            format.html { redirect_to :notice => 'Conflicting Event Times'}
            format.json { render :json => @event.errors, :status => :unprocessable_entity }
          end
        else
            format.html { redirect_to :notice => 'Conflicting Event Times'}
            format.json { render :json => @event.errors, :status => :unprocessable_entity }
        end
      end
  end
  
end
