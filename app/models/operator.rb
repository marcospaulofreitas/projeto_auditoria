class Operator < ApplicationRecord
  has_secure_password
  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships

  validates :nome, :email, :funcao, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :funcao, inclusion: { in: ['Gestor', 'Auditor da Qualidade', 'Tecnico do Suporte'] }

  scope :auditores, -> { where(funcao: 'Auditor') }
  scope :gestores, -> { where(funcao: 'Gestor') }
  scope :tecnicos, -> { where(funcao: 'Tecnico') }
end