class Review < ApplicationRecord
  belongs_to :reservation

  validates :review_text, :review_grade, presence: true
  validates :reservation_id, uniqueness: {
    message: "essa reserva já foi avaliada"
  }
  validate :reservation_must_be_finished
  private

  def reservation_must_be_finished
    return if self.reservation.nil?
    errors.add(:reservation_id, "precisa estar finalizada para avaliar") unless self.reservation.finished?
  end
end
