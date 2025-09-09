class AddAuditorToQualityCases < ActiveRecord::Migration[8.0]
  def change
    add_reference :quality_cases, :auditor, null: true, foreign_key: { to_table: :operators }
  end
end
