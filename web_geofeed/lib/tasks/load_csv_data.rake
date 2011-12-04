namespace :db do

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
    csv.foreach("data.csv") do |row|
      if counter == 1
        headers = row.collect { |r| r.downcase.to_sym }
        puts headers.collect { |h| "#{h}:string"}.join(" ")
      else
        career = Career.new
        headers.each_with_index do |h,i|
          career.send((h.to_s+"=").to_sym, row[i])
        end
      end
      counter +=1
    end
  end
end
