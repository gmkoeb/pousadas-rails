class Review < ApplicationRecord
  belongs_to :reservation

  validates :review_text, :review_grade, presence: true
  validates :reservation_id, uniqueness: {
    message: "essa reserva já foi avaliada"
  }
end
