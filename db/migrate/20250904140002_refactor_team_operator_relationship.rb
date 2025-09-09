class RefactorTeamOperatorRelationship < ActiveRecord::Migration[8.0]
  def change
    add_reference :operators, :team, foreign_key: true, index: true
    remove_reference :teams, :gestor, foreign_key: { to_table: :operators } # Remove foreign key constraint
    remove_column :teams, :gestor_id, :integer # Remove the column
  end
end
