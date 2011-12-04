class PublicController < ApplicationController
  protect_from_forgery


  def search
    if session[:tip].nil?
      session[:tip] = @tip = true 
    end
    
    @tipos_instituciones = [] + Career.all.collect(&:tipo_institucion).uniq
    @instituciones = [] + Career.all.collect{|c| c.institucion.truncate(32)}.uniq
    @carreras = [] + Career.all.collect{|c|c.carrera.truncate(43)}.uniq
    @search = Career.search(params[:search])
    @careers = @search.all.shift(25)
    @max_range = Career.maximum("promedio_arancel")
    @min_range = Career.minimum("promedio_arancel")
    @map_feed_url = "http://maps.google.com/maps/api/staticmap?size=512x512&markers=size:mid|color:red|"
    markers = ''
    @careers.each do |career|
      markers += "#{career.direccion_casa_central},Chile|"
    end
    @map_feed_url += (markers + "&mobile=true&sensor=false")
    params[:search] ||= Hash.new
    @search.promedio_arancel_greater_than ||= @min_range
    @search.promedio_arancel_less_than ||= @max_range
    @search.promedio_psu_less_than ||= 850
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @careers }
    end
  end


end
