class CharactersController < ApplicationController
  before_action :set_character, only: [:show, :show_info, :edit, :update, :destroy]
  before_action :authenticate_user!, except: ["index", "show", "show_info"]
  before_action {authenticate_world(params[:world_id])}
  before_action only: ["new", "edit", "create", "update", "destroy"] {authenticate_world(params[:world_id], "write")}

  # GET /characters
  # GET /characters.json
  def index
    @characters = @world.characters
  end

  # GET /characters/1
  # GET /characters/1.json
  def show
  end
  
  def show_deleted
    @chars = Character.destroyed_models(@world)
    
    render layout: false
  end
  
  def show_info
    @char_name = @character.name
    @character = @character.versions[params[:version].to_i].reify if params[:version]
    render layout: false
  end

  # GET /characters/new
  def new
    @character = Character.new
    @character.name = params[:name] 
  end

  # GET /characters/1/edit
  def edit
  end

  # POST /characters
  # POST /characters.json
  def create
    @character = Character.new(character_params)
    @character.world = @world
    respond_to do |format|
      if @character.save
        format.html { redirect_to world_character_path(@world, @character), notice: 'Character was successfully created.' }
        format.json { render :show, status: :created, location: @character }
      else
        format.html { render :new }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /characters/1
  # PATCH/PUT /characters/1.json
  def update
    respond_to do |format|
      old_name = @character.name if params[:persist]
      
      if @character.update(character_params)
        Event.change_names(@world, old_name, @character.name) if params[:persist]
        
        format.html { redirect_to world_character_path(@world, @character), notice: 'Character was successfully updated.' }
        format.json { render :show, status: :ok, location: @character }
        #format.js{}
      else
        format.html { render :edit }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /characters/1
  # DELETE /characters/1.json
  def destroy
    if params[:persist]
      @character.aliases.each do |a|
        Event.change_names(@world, a.name, @character.name) 
      end
    end
    @character.destroy
    respond_to do |format|
      format.html { redirect_to world_characters_url(@world), notice: 'Character was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_character
      @character = Character.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def character_params
      params.require(:character).permit(:name, :slug, :description, :age, :nicknames, :avatar, :user_id)
    end
end
