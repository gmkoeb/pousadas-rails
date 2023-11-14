class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :guests, :check_in, :check_out, presence: true

  validate :room_supports_guests
  validate :invalid_date

  private
  
  def room_supports_guests
    errors.add(:base, 'Esse quarto não suporta essa quantidade de hóspedes') if self.guests > room.maximum_guests
  end

  def invalid_date
    return if self.check_in.nil? || self.check_out.nil? 
    errors.add(:base, 'Data de check-in precisa ser anterior à data de check-out') if self.check_in > self.check_out  
  end 
end
