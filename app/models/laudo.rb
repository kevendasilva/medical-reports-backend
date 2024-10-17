class Laudo < ApplicationRecord
  # Validando a presença dos parâmetros
  validates :data,    presence: true
  validates :crm,     presence: true
  validates :texto,   presence: true
  validates :arquivo, presence: true
end
