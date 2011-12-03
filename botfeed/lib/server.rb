class Server
  SELENIUM_LOG = CONFIG["selenium_log"] || "log/selenium_#{BOT_NAME}.log"
  SELENIUM_JAR = CONFIG["selenium_jar"] || "lib/selenium-server.jar"
  SELENIUM_PID = CONFIG["selenium_pid"] || "tmp/selenium_#{BOT_NAME}.pid"
  SELENIUM_PORT = CONFIG["selenium_port"] || 4444
  FIREFOX_DISPLAY = CONFIG["firefox_display"] || "auto"
  FIREFOX_PROFILE = CONFIG["firefox_profile"] ? "-firefoxProfileTemplate \"#{ CONFIG["firefox_profile"] }\"" : nil

  def self.run!
    if self.running?
      LOG.info "Este bot ya tiene su Selenium andando. Cerrando Selenium anterior para iniciar uno nuevo..."      
      self.stop!
    end
    raise "La opcion 'firefox_display' debe ser un numero o 'auto'" unless FIREFOX_DISPLAY.to_s.match /\d|auto/
    if FIREFOX_DISPLAY == "auto"
      display_env_variable="" #no se elige ningun display
    else
      display_env_variable="DISPLAY=:#{FIREFOX_DISPLAY} " #se esta usando Xvfb
    end

    LOG.info "Iniciando Selenium Puerto #{SELENIUM_PORT}"

    LOG.info `#{display_env_variable}java -jar #{SELENIUM_JAR} #{FIREFOX_PROFILE} -ensureCleanSession -port #{SELENIUM_PORT} > #{SELENIUM_LOG} & echo $! > #{SELENIUM_PID}`
    @selenium_process = $?
    LOG.info "Esperando 30 seg que comience Selenium...#{Time.now}"
    sleep 30
  end

  def self.stop!
    LOG.info "Matando proceso Selenium"
    `kill $(cat #{SELENIUM_PID})`
    `rm #{SELENIUM_PID}`
  end

  def self.running?
    r = `cat #{SELENIUM_PID}`
    !r.blank?
  end

end
