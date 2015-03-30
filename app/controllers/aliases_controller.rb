class AliasesController < ApplicationController
  before_action {authenticate_world(params[:world_id])}
  before_action :set_alias, only: [:update, :destroy]
  def match
    #@world = World.find_by_token(params[:world_id])
    
    char = Concept.find_by_id params[:id]
    bad_names = []
    names = params[:val]
  
    names.squish.split(",").each do |name|
      unless c = @world.concepts.find_by_name(name.squish)
        n = @world.aliases.find_by_name(name.squish)
        c = n.concept if n
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
      @concept = @world.concepts.find params[:id]
      render "concept_name", layout: false
    elsif params[:what] == "edit"
      @alias = @world.aliases.find params[:id]
      render layout: false
    elsif params[:what] == "remove"
      @alias = @world.aliases.find params[:id]
      render "destroy", layout: false
    end
  end
  
  # PATCH/PUT /concepts/1
  # PATCH/PUT /concepts/1.json
  def update
    respond_to do |format|
      old_name = @alias.name if params[:persist]
      
      if @alias.update(alias_params)
        Event.change_names(@world, old_name, @alias.name) if params[:persist]
        
        format.html { redirect_to world_concept_path(@world, @alias.concept), notice: 'Name was successfully updated.' }
        format.json { render :show, status: :ok, location: @alias }
        #format.js{}
      else
        format.html { render :edit }
        format.json { render json: @alias.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    Event.change_names(@world, @alias.name, @alias.concept.name) if params[:persist]
    @alias.destroy
    respond_to do |format|
      format.html { redirect_to world_concept_path(@world, @alias.concept), notice: 'Nickname was successfully removed.' }
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
      params.require(:alias).permit(:name, :concept_id)
    end
end
