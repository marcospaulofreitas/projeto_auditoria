class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :nome
      t.string :gestor

      t.timestamps
    end
  end
end
