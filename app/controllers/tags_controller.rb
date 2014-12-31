class TagsController < ApplicationController
  def index
    @world = World.find_by_token(params[:world_id])
    @tags = @world.tags.all
    
    respond_to do |format|
      format.html { render layout: false }
      format.json { 
        tags = @tags.map do |t|
          {id: t.content, text: t.content }
        end
        
        render json: tags
      
      }
    end
  end
end
