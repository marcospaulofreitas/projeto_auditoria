class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.references :quality_case, null: false, foreign_key: true
      t.date :data_contato
      t.time :hora_contato
      t.string :contato_com
      t.text :registro_contato

      t.timestamps
    end
  end
end
