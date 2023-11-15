class Reservation < ApplicationRecord
  extend FriendlyId
  friendly_id :code, use: :slugged

  belongs_to :user
  belongs_to :room

  validates :guests, :check_in, :check_out, presence: true

  validate :room_supports_guests
  validate :invalid_date
  validate :room_is_reserved, on: :create

  before_validation :generates_code, on: :create

  enum status: {pending: 0, active: 2, canceled: 4, finished: 6}

  private
  
  def generates_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def room_supports_guests
    return if self.guests == nil
    errors.add(:base, 'Esse quarto não suporta essa quantidade de hóspedes') if self.guests > room.maximum_guests
  end

  def room_is_reserved
    unless Reservation.where(room: room).active.empty? 
      errors.add(:base, 'Esse quarto já está reservado')
    end
  end
  def invalid_date
    return if self.check_in.nil? || self.check_out.nil? 
    errors.add(:base, 'Data de check-in precisa ser anterior à data de check-out') if self.check_in > self.check_out  
  end 
end
