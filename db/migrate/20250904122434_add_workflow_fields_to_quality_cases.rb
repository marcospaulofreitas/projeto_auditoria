class AddWorkflowFieldsToQualityCases < ActiveRecord::Migration[8.0]
  def change
    add_column :quality_cases, :data_pesquisa_satisfacao, :date
    add_column :quality_cases, :data_registro, :datetime
    add_column :quality_cases, :analise_atendimento, :text
    add_column :quality_cases, :analise_conhecimento, :text
    add_column :quality_cases, :analise_procedimental, :text
    add_column :quality_cases, :acoes_corretivas_propostas, :text
    add_column :quality_cases, :acoes_adotadas, :text
    add_column :quality_cases, :motivo_recusa, :text
    add_column :quality_cases, :informacoes_reanalise, :text
    add_column :quality_cases, :motivo_manutencao, :text
    add_column :quality_cases, :contatos_sucesso, :integer, default: 0
    add_column :quality_cases, :contatos_insucesso, :integer, default: 0
  end
end
