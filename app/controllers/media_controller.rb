class MediaController < ApplicationController
  def create
    if m = Medium.create(content: params[:file])
      render json: {
        image: {
          url: m.content.url
        }
      }, content_type: "text/html"
    end
  end
end
