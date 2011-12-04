class PublicController < ApplicationController
  protect_from_forgery

  # GET /careers
  # GET /careers.json
  def search
       @search = Career.search(params[:search])
       @careers = @search.all
       Rails.logger.info "#{@careers.count} carreras encontradas..."

    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @careers }
    end
  end
  
end
