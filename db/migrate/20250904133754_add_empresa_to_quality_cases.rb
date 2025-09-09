class AddEmpresaToQualityCases < ActiveRecord::Migration[8.0]
  def change
    add_column :quality_cases, :empresa, :string
  end
end
