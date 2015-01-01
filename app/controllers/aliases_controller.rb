class AliasesController < ApplicationController
  before_action except: ["match"] {authenticate_world(params[:world_id])}
  before_action :set_alias, only: [:update, :destroy]
  def match
    @world = World.find_by_token(params[:world_id])
    
    char = Character.find_by_id params[:id]
    bad_names = []
    names = params[:val]
  
    names.squish.split(",").each do |name|
      unless c = Character.find_by_name(name.squish)
        n = Alias.find_by_name(name.squish)
        c = n.character if n
      end
    
      if c && char != c
        bad_names.push name
      end
    end
      
    if bad_names.length > 0
      render :json => { :success => false, :msg => "#{bad_names.join(", ")} is already taken" }
    else
      render :json => { :success => true }
    end
  end
  
  def edit
    if params[:what] == "name"
      @character = @world.characters.find params[:id]
      render "character_name", layout: false
    elsif params[:what] == "edit"
      @alias = @world.aliases.find params[:id]
      render layout: false
    elsif params[:what] == "remove"
      @alias = @world.aliases.find params[:id]
      render "destroy", layout: false
    end
  end
  
  # PATCH/PUT /characters/1
  # PATCH/PUT /characters/1.json
  def update
    respond_to do |format|
      old_name = @alias.name if params[:persist]
      
      if @alias.update(alias_params)
        Event.change_names(@world, old_name, @alias.name) if params[:persist]
        
        format.html { redirect_to world_character_path(@world, @alias.character), notice: 'Name was successfully updated.' }
        format.json { render :show, status: :ok, location: @alias }
        #format.js{}
      else
        format.html { render :edit }
        format.json { render json: @alias.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    Event.change_names(@world, @alias.name, @alias.character.name) if params[:persist]
    @alias.destroy
    respond_to do |format|
      format.html { redirect_to world_character_path(@world, @alias.character), notice: 'Nickname was successfully removed.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alias
      @alias = @world.aliases.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alias_params
      params.require(:alias).permit(:name, :character_id)
    end
end
