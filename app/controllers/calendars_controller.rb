class CalendarsController < ApplicationController
  # GET /calendars
  # GET /calendars.json
  before_filter :authenticate_user!, :check_correct_user!
  
  def check_correct_user!
    if params[:id]
      @calendar = Calendar.find(params[:id])
      unless current_user.calendars.include?(@calendar)
        flash[:warning] = "That doesn't belong to you..."
        redirect_to calendars_path
      end
    end
  end
  
  def index
    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month, :conditions => ['user_id = ?', current_user.id])

    # To restrict what events are included in the result you can pass additional find options like this:
    #
    # @event_strips = Event.event_strips_for_month(@shown_month, :include => :some_relation, :conditions => 'some_relations.some_column = true')
    #

  end

  # GET /calendars/1
  # GET /calendars/1.json
  def show
    @calendar = Calendar.find(params[:id])
    @events = Event.find(@calendar.event_ids)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @calendar }
    end
  end

  # GET /calendars/new
  # GET /calendars/new.json
  def new
    @calendar = Calendar.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @calendar }
    end
  end

  # GET /calendars/1/edit
  def edit
    @calendar = Calendar.find(params[:id])
  end

  # POST /calendars
  # POST /calendars.json
  def create
    @calendar = Calendar.new(params[:calendar])
    @calendar.user_id = current_user.id

    respond_to do |format|
      if @calendar.save
        format.html { redirect_to @calendar, :notice => 'Calendar was successfully created.' }
        format.json { render :json => @calendar, :status => :created, :location => @calendar }
      else
        format.html { render :action => "new" }
        format.json { render :json => @calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /calendars/1
  # PUT /calendars/1.json
  def update
    @calendar = Calendar.find(params[:id])

    respond_to do |format|
      if @calendar.update_attributes(params[:calendar])
        format.html { redirect_to @calendar, :notice => 'Calendar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy

    respond_to do |format|
      format.html { redirect_to calendars_url }
      format.json { head :no_content }
    end
  end
end
