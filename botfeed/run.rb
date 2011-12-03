#argumentos correctos?

VALID_BOTS = ['aranceles']

bot_name = nil

if ARGV == ["aranceles"]
  require './bots/bot_aranceles'
  bot_name = 'aranceles'
end

#LOG = Logger.new(STDOUT)
# http://rubylearning.com/satishtalim/ruby_logging.html
require 'rubygems'
require 'action_mailer'
require 'logger'

LOG = Logger.new("log/bot#{bot_name}.log",'daily')

if bot_name.nil?
  msg = "No se ingreso nombre de un bot valido (#{VALID_BOTS.inspect})"
  puts msg
  LOG.fatal msg
  exit 1
end

BOT_NAME = bot_name

puts "Bot es #{BOT_NAME}"

require 'yaml'
tree = YAML::parse( File.open( "config/bot.yml" ) )
config = tree.transform['bot'][BOT_NAME]
# se puede sobreescribir configuracion con variables de entorno, pero antes de guardarlo en constante
# config = config.merge!('csv_filename' => ENV['BOT_CSV_FILENAME']) if ENV['BOT_CSV_FILENAME']
config = config.merge!('rut' => ENV['BOT_RUT']) if ENV['BOT_RUT']
config = config.merge!('clave' => ENV['BOT_CLAVE']) if ENV['BOT_CLAVE']
config = config.merge!('cta' => ENV['BOT_CTA']) if ENV['BOT_CTA']

#    rut: "13699304-6"
#    clave: "kmmulti11"
#    cta: "35406402"

CONFIG = config

require './lib/server' 

if CONFIG['mailer']['delivery_method'] == 'mutt'
  require './lib/mailer_mutt' 
else
  require './lib/mailer' 
end

MAILER = Mailer

# Constantes a tener en cuenta:
# - LOG es el logger usado por el bot (LOG.info, .fatal, etc)
# - CONFIG cargar el bot.yml como configuracion ( CONFIG['mailer']['mail_to'] por ej, etc)
# - Mailer se usa para enviar notificaciones y usa la configuracion de bot.yml (Mailer.notification(mail,msg).deliver )
# - Server se usa para levantar o bajar el servidor selenium
# OJO: Las constantes son usadas dentro del bot y el bot dara error si no las encuentra.
# SE RECOMIENDA: instalar Firefox 3.6.13 si no se ha hecho ya

LOG.info "[#{Time.now.in_time_zone('Santiago')}] Corriendo bot... "

n = 0 
e = true

Server.run!

while (n < CONFIG['restarts'] || CONFIG['restarts'] == 0)

 begin
   LOG.info "Bot Start #{n+1}"
   LOG.info "Started at #{Time.now}"

   Test::Unit::AutoRunner.run  # e=true todo bien, e=false hubo un error en tests
   
   n = n + 1
 rescue Interrupt => e
   LOG.info "bot cerrado por interrupt (CTRL+C)"
   break
 rescue Exception => e
   LOG.info "browser restarted por exception #{e.inspect}"
 end
 
end 

#MAILER.notification('Bot terminado').deliver
LOG.info "Bot Terminado"

Server.stop!

# se revisa si selenium esta corriendo
unless e

  LOG.fatal 'Hubo un error al ejecutar el bot'
  #LOG.fatal 'Recordar que Selenium debe estar instalado y corriendo. Puede descargar selenium standalone server desde http://code.google.com/p/selenium/downloads/list'
  #MAILER.notification('Bot termino con erroneamente').deliver

end
