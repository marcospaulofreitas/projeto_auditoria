class UpdateTeamsStructure < ActiveRecord::Migration[8.0]
  def change
    remove_column :teams, :gestor, :string
    add_reference :teams, :gestor, foreign_key: { to_table: :operators }
    add_column :teams, :operator_ids, :text
  end
end