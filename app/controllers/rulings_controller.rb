class RulingsController < ApplicationController
  before_action {authenticate_world(params[:world_id], "admin")}
  def index
    @rulings = @world.rulings.includes(:user)
    @ruling = @world.rulings.new
  end
  
  def create
    @ruling = Ruling.new(ruling_params)
    @ruling.world = @world
    respond_to do |format|
      if @ruling.save
        format.html { redirect_to world_rulings_path(@world), notice: 'Collaborator was successfully added.' }
      else
        format.html { render :index }
        format.json { render json: @world.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @ruling = Ruling.find(params[:id])
    respond_to do |format|
      if @ruling.update(ruling_params)
        format.js{}
      end
    end
  end
  
  def destroy
    @ruling = Ruling.find(params[:id])
    @ruling.destroy
    respond_to do |format|
      format.html { redirect_to world_rulings_path(@world), notice: 'User was successfully removed.' }
      format.json { head :no_content }
    end
  end
  
  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def ruling_params
    params.require(:ruling).permit(:email, :role)
  end
end

