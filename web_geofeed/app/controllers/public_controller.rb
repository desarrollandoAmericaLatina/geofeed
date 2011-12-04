class PublicController < ApplicationController
  protect_from_forgery
  

  def search
       @search = Career.search(params[:search])
       @careers = @search.all
       Rails.logger.info "#{@careers.count} carreras encontradas..."
       @max_range = Career.maximum("promedio_arancel")
       @min_range = Career.minimum("promedio_arancel")

    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @careers }
    end
  end
  
 
 
end
