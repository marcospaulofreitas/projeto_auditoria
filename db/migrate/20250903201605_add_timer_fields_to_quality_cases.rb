class AddTimerFieldsToQualityCases < ActiveRecord::Migration[8.0]
  def change
    add_column :quality_cases, :contato_started_at, :datetime
    add_column :quality_cases, :analise_started_at, :datetime
  end
end
