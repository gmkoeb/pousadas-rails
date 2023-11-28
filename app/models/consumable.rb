class Consumable < ApplicationRecord
  belongs_to :reservation

  validates :name, :value, presence: true

  validates :value, numericality: {greater_than: 0}
end
