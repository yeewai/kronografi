class ConceptsController < ApplicationController
  before_action :set_concept, only: [:show, :show_info, :edit, :update, :destroy]
  before_action :authenticate_user!, except: ["index", "show", "show_info"]
  before_action {authenticate_world(params[:world_id])}
  before_action only: ["new", "edit", "create", "update", "destroy"] {authenticate_world(params[:world_id], "write")}

  # GET /concepts
  # GET /concepts.json
  def index
    @concepts = @world.concepts.group_by(&:kind)
  end

  # GET /concepts/1
  # GET /concepts/1.json
  def show
  end
  
  def show_deleted
    @chars = Concept.destroyed_models(@world)
    
    render layout: false
  end
  
  def show_info
    @char_name = @concept.name
    @concept = @concept.versions[params[:version].to_i].reify if params[:version]
    render layout: false
  end

  # GET /concepts/new
  def new
    @concept = Concept.new
    @concept.name = params[:name] 
    @concept.kind = params[:kind]
  end

  # GET /concepts/1/edit
  def edit
  end

  # POST /concepts
  # POST /concepts.json
  def create
    @concept = Concept.new(concept_params)
    @concept.world = @world
    respond_to do |format|
      if @concept.save
        format.html { redirect_to world_concept_path(@world, @concept), notice: 'Concept was successfully created.' }
        format.json { render :show, status: :created, location: @concept }
      else
        format.html { render :new }
        format.json { render json: @concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /concepts/1
  # PATCH/PUT /concepts/1.json
  def update
    respond_to do |format|
      old_name = @concept.name if params[:persist]
      
      if @concept.update(concept_params)
        Event.change_names(@world, old_name, @concept.name) if params[:persist]
        
        format.html { redirect_to world_concept_path(@world, @concept), notice: 'Concept was successfully updated.' }
        format.json { render :show, status: :ok, location: @concept }
        #format.js{}
      else
        format.html { render :edit }
        format.json { render json: @concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /concepts/1
  # DELETE /concepts/1.json
  def destroy
    if params[:persist]
      @concept.aliases.each do |a|
        Event.change_names(@world, a.name, @concept.name) 
      end
    end
    @concept.destroy
    respond_to do |format|
      format.html { redirect_to world_concepts_url(@world), notice: 'Concept was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_concept
      @concept = Concept.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def concept_params
      params.require(:concept).permit(:name, :slug, :description, :age, :nicknames, :avatar, :user_id, :kind)
    end
end
