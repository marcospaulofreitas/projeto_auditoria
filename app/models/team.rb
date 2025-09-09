class Team < ApplicationRecord
  has_many :quality_cases, dependent: :destroy
  has_many :team_memberships, dependent: :destroy
  has_many :operators, through: :team_memberships

  def gestor
    operators.find_by(funcao: 'Gestor')
  end

  validates :nome, presence: true, uniqueness: true
  

  
end