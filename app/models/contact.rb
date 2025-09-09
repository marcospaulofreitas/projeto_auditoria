class Contact < ApplicationRecord
  belongs_to :quality_case

  validates :data_contato, :hora_contato, :contato_com, :registro_contato, presence: true
end
