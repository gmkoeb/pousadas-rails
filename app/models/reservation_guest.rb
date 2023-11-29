class ReservationGuest < ApplicationRecord
  belongs_to :reservation

  validates :name, :registration_number, :age, presence: true

end
