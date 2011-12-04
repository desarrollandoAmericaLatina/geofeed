class AddDireccionCasaCentralToCareer < ActiveRecord::Migration
  def change
    add_column :careers, :direccion_casa_central, :string
  end
end
