class Consumable < ApplicationRecord
  belongs_to :reservation

  validates :name, :value, presence: true

  validates :value, numericality: {greater_than: 0}

  validate  :active_reservation?
  private

  def active_reservation?
    errors.add(:reservation_id, 'deve estar ativa') if !self.reservation.active?
  end
end
