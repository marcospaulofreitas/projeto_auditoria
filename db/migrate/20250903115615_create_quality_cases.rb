class CreateQualityCases < ActiveRecord::Migration[8.0]
  def change
    create_table :quality_cases do |t|
      t.string :numero_chamado
      t.string :tecnico
      t.string :cliente
      t.date :data_chamado
      t.date :data_avaliacao
      t.string :status
      t.text :insatisfacao_cliente
      t.date :data_contato
      t.time :hora_contato
      t.string :contato_com
      t.text :feedback_cliente
      t.text :analise_qualidade
      t.text :acoes_corretivas
      t.text :retorno_cliente
      t.text :retorno_gestor

      t.timestamps
    end
  end
end
