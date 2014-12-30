class AliasesController < ApplicationController
  def match
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
end
