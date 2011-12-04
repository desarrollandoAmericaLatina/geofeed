class PublicController < ApplicationController
  protect_from_forgery
  

  def search
       @search = Career.search(params[:search])
       @careers = @search.all.shift(10)
       Rails.logger.info "#{@careers.count} carreras encontradas..."
       @max_range = Career.maximum("promedio_arancel")
       @min_range = Career.minimum("promedio_arancel")
       @map_feed_url = "http://maps.google.com/maps/api/staticmap?size=512x512&markers=size:mid|color:red|"
       markers = ''
       @careers.each do |career|
         markers += "#{career.direccion_casa_central}|"
       end
       @map_feed_url += (markers + "&mobile=true&sensor=false")
       params[:search] ||= Hash.new
       params[:search][:promedio_arancel_less_than] ||= @max_range
       params[:search][:promedio_arancel_greater_than] ||= @min_range
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @careers }
    end
  end

 
end
