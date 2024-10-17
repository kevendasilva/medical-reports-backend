class Laudo < ApplicationRecord
  # Validando a presença dos parâmetros
  validates :data,    presence: true
  validates :crm,     presence: true
  validates :texto,   presence: true
  validates :arquivo, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[arquivo created_at crm data id id_value texto updated_at]
  end
end
