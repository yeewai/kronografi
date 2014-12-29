class TagsController < ApplicationController
  def index
    @tags = Tag.all
    
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
