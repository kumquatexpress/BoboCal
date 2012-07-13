class TimeperiodsController < ApplicationController
  # GET /timeperiods
  # GET /timeperiods.json
  def index
    @timeperiods = Timeperiod.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @timeperiods }
    end
  end

  # GET /timeperiods/1
  # GET /timeperiods/1.json
  def show
    @timeperiod = Timeperiod.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @timeperiod }
    end
  end

  # GET /timeperiods/new
  # GET /timeperiods/new.json
  def new
    @timeperiod = Timeperiod.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @timeperiod }
    end
  end

  # GET /timeperiods/1/edit
  def edit
    @timeperiod = Timeperiod.find(params[:id])
  end

  # POST /timeperiods
  # POST /timeperiods.json
  def create
    @timeperiod = Timeperiod.new(params[:timeperiod])

    respond_to do |format|
      if @timeperiod.save
        format.html { redirect_to @timeperiod, :notice => 'Timeperiod was successfully created.' }
        format.json { render :json => @timeperiod, :status => :created, :location => @timeperiod }
      else
        format.html { render :action => "new" }
        format.json { render :json => @timeperiod.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /timeperiods/1
  # PUT /timeperiods/1.json
  def update
    @timeperiod = Timeperiod.find(params[:id])

    respond_to do |format|
      if @timeperiod.update_attributes(params[:timeperiod])
        format.html { redirect_to @timeperiod, :notice => 'Timeperiod was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @timeperiod.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /timeperiods/1
  # DELETE /timeperiods/1.json
  def destroy
    @timeperiod = Timeperiod.find(params[:id])
    @timeperiod.destroy

    respond_to do |format|
      format.html { redirect_to timeperiods_url }
      format.json { head :no_content }
    end
  end
end
