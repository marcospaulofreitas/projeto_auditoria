class RemoveContactFieldsFromQualityCases < ActiveRecord::Migration[8.0]
  def change
    remove_column :quality_cases, :data_contato, :date
    remove_column :quality_cases, :hora_contato, :time
    remove_column :quality_cases, :contato_com, :string
    remove_column :quality_cases, :feedback_cliente, :text
  end
end
