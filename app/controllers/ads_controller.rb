class AdsController < ApplicationController
  def show
    if Rails.env.test?
      render nothing: true, :status => 200, :content_type => 'text/html'
    else
      render layout: false
    end
  end
  
  def show_leader
    render layout: false
  end
end
