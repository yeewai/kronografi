class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :update_happened, :destroy]
  before_action :authenticate_user!
  before_action except: ["valid_date"] {authenticate_world(params[:world_id])}
  before_action only: ["new", "edit", "create", "update", "update_happened", "destroy"] {authenticate_world(params[:world_id], "write")}

  # GET /events
  # GET /events.json
  def index
    @start_event = @world.events.find_or_initialize_by summary: "Story Starts"
    @event = Event.new
    @tags = @world.tags
    @characters = @world.characters
    @year = params[:this_year]
  end
  
  def years
    @start_event = @world.events.find_by_kind "start"
    @events = @world.events.all.order(:happened_on).includes(:tags, :characters).group_by(&:happened_key)
    if params[:start_year] && params[:end_year]
      @year_range = params[:start_year].to_i..params[:end_year].to_i
    elsif @start_event
      start = [@start_event.happened_on.year-5, @world.events.all.sort_by(&:happened_on).first.happened_on.year].min
      finish = [@start_event.happened_on.year+5, @world.events.order(:happened_on).last.happened_on.year].max
      @year_range = start..finish
    else
      @year_range = []
    end
    
    render layout: false
  end
  
  def months
    @start_event = @world.events.find_by_kind "start"
    @year = params[:year].to_i
    if Rails.env.production?
      #For PG
      @events = @world.events.where('extract(year from happened_on) = ?', @year.to_s).order(:happened_on).includes(:tags, :characters).group_by{|e| e.happened_on.month}
    else
      #for sqlite
      @events = @world.events.where("strftime('%Y', happened_on)= ?", @year.to_s).order(:happened_on).includes(:tags, :characters).group_by{|e| e.happened_on.month}
    end
    render layout: false
  end
  
  def relative
    unless @world.events.find_by_kind("start") 
      @world.events.create summary: "Story Starts", happened_on: Date.today(), kind: "start"
    end
    
    if params[:character] && @character = Character.find_by_id( params[:character])
      @events = @character.events.includes(:tags, :characters) + @world.events.where(kind: ["milestone", "start"]).includes(:tags, :characters)
    else
      @events = @world.events.includes(:tags, :characters)
    end
      
    @events = @events.sort_by(&:happened_on)
    @lowest_date = @events.first.happened_on - 1.day
    render layout: false
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = @event.versions[params[:version].to_i].reify if params[:version]
  
    render layout: false
  end
  
  def show_deleted
    @events = Event.destroyed_models(@world)
    
    render layout: false
  end

  # GET /events/new
  def new
    @event = Event.new
    render partial: "form", layout: false
  end

  # GET /events/1/edit
  def edit
    render partial: "form", layout: false
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.world = @world
    respond_to do |format|
      if @event.save
        #format.html { redirect_to @event, notice: 'Event was successfully created.' }
        #format.json { render :show, status: :created, location: @event }
        format.js
      else
        #format.html { render :new }
        #format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        #format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        #format.json { render :show, status: :ok, location: @event }
        format.js {render "create"}
      #else
      #  format.html { render :edit }
      #  format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update_happened
    @event.update_attribute :happened_on, params["happened_on"]
    head :ok, content_type: "text/html"
  end
  
  def revert
    version = PaperTrail::Version.find(params[:version].to_i)
    reified = version.reify
    name_is_changed = ((version.item_type == "Character") && reified.name_changed? && (version.event != "destroy"))
    respond_to do |format|
      if reified.save
        if name_is_changed
          pv = reified.previous_version
          Event.change_names(@world, pv.name_change[1], pv.name_change[0])
        end
        version.delete
        format.js {render "create"}
        format.html {
          redirect_to world_characters_path(@world) if version.item_type == "Character"
        }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      #format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      #format.json { head :no_content }
      format.js
    end
  end
  
  def valid_date
    begin
       Date.parse(params[:val])
    rescue ArgumentError
       bad_date = true
    end
    
    if bad_date
      render :json => { :success => false, :msg => "Invalid Date" }
    else
      render :json => { :success => true }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:summary, :details, :set_happened, :happened_on, :set_tags, :kind, :user_id)
    end
end
