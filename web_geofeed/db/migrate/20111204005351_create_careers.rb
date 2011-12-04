class CreateCareers < ActiveRecord::Migration
  def change
    create_table :careers do |t|
      t.string :tipo_institucion
      t.string :carrera
      t.string :institucion
      t.string :areas_conocimiento
      t.float :empleabilidad_primer_ano
      t.float :empleabilidad_segundo_ano
      t.string :region_mayor_numero_titulados
      t.integer :n_matriculados_primer_ano
      t.integer :n_matriculados_total
      t.string :estudiantes_municipales
      t.string :estudiantes_particular_subvencionado
      t.string :estudiantes_particular_pagado
      t.float :porcentaje_estudiantes_psu
      t.integer :promedio_psu
      t.float :promedio_nem
      t.float :tasa_retencion_primer_ano
      t.float :tasa_retencion_segundo_ano
      t.integer :n_titulados
      t.float :duracion_esperada
      t.float :duracion_real
      t.integer :promedio_arancel

      t.timestamps
    end
  end
end
