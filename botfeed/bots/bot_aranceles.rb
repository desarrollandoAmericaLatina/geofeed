require "./bots/bot_base"

class BotAranceles < Test::Unit::TestCase
  include BotBase
  
  def bot_get_cartola
    #doc = open("html/cartola_santander.html") { |f| Hpricot(f) }.to_s
    @selenium.open "http://www.becasycreditos.cl/aranceles_referencia.html"
    @selenium.wait_for_page_to_load "30000"
    puts @selenium.get_html_source
    return     
    doc = Hpricot(@selenium.get_html_source).to_s
    
    parts = doc.split("<!-- Detalle Movimientos -->")
    
    doc = Hpricot(parts[1])

    #doc = Hpricot(@selenium.get_html_source)
    list = doc.at("div[@id='tablalista'] table tbody").search('tr')
    
    #sacamos la primera fila en blanco
    list = list[1..list.count]

    headers = "Fecha	,Sucursal	,Detalle de Transaccion	,N Dcto,	Cheques y Otros Cargos,	Depositos y Otros Abonos,	Saldo"
    headers = headers.split(',')
    # ACA SE HACE ALGO CON LOS DATOS SE PUEDEN PASAR A UN EXCEL O BD
    File.open(file_to_open('santander'), 'w') do |f2|
      f2.puts headers.join(' ,')
      list.each do |tr|
        row = tr.search('td').collect{|r| clean_td(r.inner_html)} #[0..6]
        line = []
        if row.count != headers.count            
          LOG.fatal "#{row.inspect} != #{headers.inspect}"
          raise 'row with more cells than headers' 
        end
        f2.puts row.join(' ,')
      end
    end
  end
  

  def clean_td cell
    t = cell.strip
    if t['<font']
      parts = t.split('>')
      t = parts[1].split('<')[0]
    end
    t.gsub('&nbsp;','').strip
  end

end
