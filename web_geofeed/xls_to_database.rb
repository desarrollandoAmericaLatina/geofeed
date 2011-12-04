namespace :db do

  desc "load user data from csv"
  task :load_csv_data  => :environment do
    require 'fastercsv'
    counter = 0
    FasterCSV.foreach("data.csv") do |row|
      if counter > 1
        career = Career.new
        headers.each_with_index do |h,i|
          career.send((h.to_s+"=").to_sym, row[i])
        end
        career.send
      else
        headers = row.collect { |r| r.downcase.to_sym }
      end
    end
    puts "HEADERS => #{headers}"
  end
end
