#coding:utf-8
namespace :db do

  def convert(str)
    ac=["Á","É","Í","Ó", "Ú"]
    sa=["A","E","I", "O", "U"]
    str = str.encode("UTF-8")
    ac.each_with_index do |x,i|
      str.gsub!(x,sa[i])
    end
    str
  end

  desc "load user data from csv"
  task :load_csv_data  => :environment do
    require 'csv'
    require 'fastercsv'
    counter = 1
    if CSV.const_defined? :Reader
      csv = FasterCSV
    else
      csv = CSV
    end
    headers =[]
    csv.foreach("data3.csv") do |row|
      if counter == 1
        headers = row.collect { |r| r.downcase.to_sym }.compact
        puts headers.collect { |h| "#{h}:string"}.join(" ")
      else
        career = Career.new
        headers.each_with_index do |h,i|
          puts "row #{i} #{row[i]}"
          if row[i].nil?
            v = 0
          else
            v = row[i].force_encoding('UTF-8').gsub(".","")
            v = convert(v)
          end
          career.send((h.to_s + "=").to_sym, v)
        end
        career.save!
      end
      counter +=1
    end
  end

  desc "Task description"
  task :calculate_payback => :environment do
    careers = Career.all
    careers.each do |c|
      tasa1 = c.empleabilidad_primer_ano/100
      tasa2 = c.empleabilidad_segundo_ano/100
      arancel = c.promedio_arancel
      renta = 0
      i = 1
      while(arancel*c.duracion_esperada>renta && i < 20) do
         a = arancel*c.duracion_esperada
         if i == 1
           tasa = tasa1
         elsif tasa2 <= 0
           tasa = tasa1
         else
           tasa = tasa2
         end
         if i >= 9
           renta = renta + c.send("ingreso_ano_8".to_sym)*tasa*12
         else
           renta = renta + c.send("ingreso_ano_#{i}".to_sym)*tasa*12
         end
         i+=1
      end
      c.payback = i
      c.save!
    end
  end
end
