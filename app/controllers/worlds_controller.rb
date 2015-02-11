class WorldsController < ApplicationController
  before_action :authenticate_user!
  before_action only: [:edit, :update, :destroy, :settings] {authenticate_world(params[:id])}

  # GET /worlds
  # GET /worlds.json
  def index
    @worlds = current_user.worlds.all
  end

  ## GET /worlds/1
  ## GET /worlds/1.json
  #def show
  #end

  # GET /worlds/new
  def new
    @world = World.new
  end

  # GET /worlds/1/edit
  def edit
  end

  # POST /worlds
  # POST /worlds.json
  def create
    @world = World.new(world_params)
    @world.user = current_user

    respond_to do |format|
      if @world.save
        format.html { redirect_to world_events_path(@world), notice: 'World was successfully created.' }
        format.json { render :show, status: :created, location: @world }
      else
        format.html { render :new }
        format.json { render json: @world.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /worlds/1
  # PATCH/PUT /worlds/1.json
  def update
    respond_to do |format|
      if @world.update(world_params)
        format.html { 
          if @world.scale == "months" && (start = @world.events.find_by_kind("start"))
            redirect_to world_events_path(@world, start.happened_on.year), notice: 'World was successfully updated.'
          else
            redirect_to world_events_path(@world), notice: 'World was successfully updated.' 
          end
        }
        format.json { render :show, status: :ok, location: @world }
      else
        format.html { render :edit }
        format.json { render json: @world.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def settings
  end
  
  def update_collaborators
  end

  # DELETE /worlds/1
  # DELETE /worlds/1.json
  #def destroy
  #  @world.destroy
  #  respond_to do |format|
  #    format.html { redirect_to worlds_url, notice: 'World was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def world_params
      params.require(:world).permit(:name, :description, :is_absolute, :scale, :is_public)
    end
end
