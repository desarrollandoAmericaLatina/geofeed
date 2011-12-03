# MultiBot
 
## Objetivo

Scrapping de sitios web.

## Directorios importantes

```
  config/bot.yml        archivo de configuración de bots
  bots/      		están todos los bots que se pueden ejecutar usando el multibot.
  lib/       		donde se pueden encontrar librerias adhoc o externas usadas por el bot (Jar Selenium, mailer.rb, etc)
  log/       		donde se guardan los logs del bot o selenium.
  tmp/       		usado para guardar archivos temporales (selenium pids, etc)
  run.rb		Para correr bot. Ej:     ruby run.rb santander  
  setup.rb 		Instala librerias necesarias para correr bots.
```

## Requisitos para correr el bot

* JDK 1.6 (para correr selenium server)
* Ruby 1.8.7 
* Firefox 3.6.13 recomendado puede que funcione con otros navegadores
* Selenium Server 2beta2 descargable en http://seleniumhq.org/download/
* Instalar gems corriendo setup.rb

## Instrucciones de uso

Correr bot que se quiera

```
  > ruby run.rb NOMBRE_BOT 
```
 


