class AddTeamToQualityCases < ActiveRecord::Migration[8.0]
  def change
    add_reference :quality_cases, :team, null: true, foreign_key: true
  end
end
