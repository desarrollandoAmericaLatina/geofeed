class AddPaybackToCareer < ActiveRecord::Migration
  def change
    add_column :careers,:payback, :integer
  end
end
