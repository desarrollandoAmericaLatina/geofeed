class AddIngresoToCareer < ActiveRecord::Migration
  def change
    8.times do |i|
      add_column :careers, ("ingreso_ano_"+ (i+1).to_s).to_sym, :integer
    end
  end
end
