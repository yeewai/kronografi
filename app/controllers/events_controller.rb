class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :update_happened, :destroy]

  # GET /events
  # GET /events.json
  def index
    @start_event = Event.find_or_initialize_by summary: "Story Starts"
    @event = Event.new
  end
  
  def years
    @start_event = Event.find_by_summary "Story Starts"
    @events = Event.where.not( summary: "Story Starts").group_by(&:happened_key)
    
    render layout: false
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  #def new
  #  @event = Event.new
  #end

  # GET /events/1/edit
  def edit
    render partial: "form", layout: false
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
        format.js
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
        format.js {render "create"}
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update_happened
    @event.update_attribute :happened_on, params["happened_on"]
    head :ok, content_type: "text/html"
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:summary, :details, :happened_on)
    end
end
