class CreateTechnicians < ActiveRecord::Migration[8.0]
  def change
    create_table :technicians do |t|
      t.string :nome
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
