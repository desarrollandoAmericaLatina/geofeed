require "test/unit"
require "rubygems"
require "hpricot"
gem "selenium-client"
require "selenium/client"

module BotBase 

  def setup  
    LOG.info "BotBase setup #{Time.now}"  
    @verification_errors = []
    @connection_attemps = 0
    begin
      @selenium = Selenium::Client::Driver.new \
        :host => CONFIG['selenium_host'],
        :port => CONFIG['selenium_port'],
        :browser => CONFIG['selenium_browser'],
        :url => CONFIG['bot_url'],
        :timeout_in_second => 60
        
      sleep 10

      @connection_attemps += 1
      @selenium.start_new_browser_session      
    rescue Exception => e
      if e.instance_of? Errno::ECONNREFUSED
        MAILER.notification("Selenium is down! exception #{e.inspect}\n#{e.backtrace.join("\n")}").deliver
        if @connection_attemps < 3          
          return setup
        end
      else
        MAILER.notification("Exception al partir selenium #{e.inspect}\n#{e.backtrace.join("\n")}").deliver
      end
      raise e
    end
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  

  def wait_n_click click_id
    wait_to_appear_visible click_id
    @selenium.click click_id
  end

  def wait_to_appear_visible id, t = 1
    #RAILS_DEFAULT_LOGGER.silence do      
      assert !(60/t).to_i.times{ break if (@selenium.is_visible(id) rescue false); sleep t }
    #end
  end

  def assert_contains_with_delay text, delay = 10
    begin
      @selenium.wait_for_text text, :timeout_in_seconds => delay
    rescue
      assert false, "no se encontro el texto: [#{text}] en los #{delay} seg. pedidos  HTML SOURCE:

    #{@selenium.get_html_source}
    "
    end
  end
  
  def file_to_open banco, config = {}
    now = Time.now.in_time_zone('Santiago')
    filepath = CONFIG['csv_filepath'] || ''
    filename = CONFIG['csv_filename']
    filename = filename.gsub('YYYYMMDD',"#{now.year}#{"%02d" % now.month}#{"%02d" % now.day}")
    filename = filename.gsub('HHMMSS',"#{"%02d" % now.hour}#{"%02d" % now.min}#{"%02d" % now.sec}")
    config.keys.each do |key|
      filename = filename.gsub(key,config[key])
    end
    file_to_open = "#{filepath}#{filename}"
  end

  # Contiene el algoritmo para ejecutar bots
  # Todos los bots deben implementar estos 3 métodos
  # - bot_to_cartola : codigo necesario para ingresar al banco(si es necesario) y llegar a ver la cartola
  # - bot_get_cartola : codigo necesario para procesar la cartola y generar csv
  # - bot_reload_cartola : codigo necesario para cargar nuevamente la cartola ojalá lo más ŕapido posible

  def test_bot
    #begin
    bot_get_cartola
  end
    #rescue Exception => e
    #  msg = "Cartola no se genero correctamente por exception: #{e} : #{e.message}


#HTML:*****************************************************************************

##{@selenium.get_html_source}

#**********************************************************************************


#"
#      LOG.fatal msg
#      MAILER.notification(msg).deliver
#      raise e
#    end

  
end
