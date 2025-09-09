class RenameTableTechniciansToOperators < ActiveRecord::Migration[8.0]
  def change
    rename_table :technicians, :operators
    add_column :operators, :email, :string
    add_column :operators, :funcao, :string
    remove_reference :operators, :team, foreign_key: true
  end
end
