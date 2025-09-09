class AddPasswordAndAuditorToOperators < ActiveRecord::Migration[8.0]
  def change
    add_column :operators, :password_digest, :string
    change_column :operators, :funcao, :string
  end
end
