class Reservation < ApplicationRecord
  extend FriendlyId
  friendly_id :code, use: :slugged

  belongs_to :user
  belongs_to :room

  validates :guests, :check_in, :check_out, presence: true

  validate :room_supports_guests
  validate :invalid_date, on: :create
  validate :room_is_reserved, on: :create
  validate :valid_user, on: [:check_in, :check_out]
  before_validation :generates_code, on: :create

  enum status: {pending: 0, active: 2, canceled: 4, finished: 6}

  private
  def valid_user
    user = User.where(inn: self.room.inn).first
    unless self.room.inn.user == user
      errors.add(:base, "Acesso negado.")
    end
  end

  def generates_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def room_supports_guests
    return if self.guests == nil
    errors.add(:guests, 'acima do suportado pelo quarto') if self.guests > room.maximum_guests
  end

  def room_is_reserved
    return if self.check_in.nil? || self.check_out.nil?
    active_reservations = Reservation.all.not_canceled.not_finished
    active_reservations.each do |reservation|
      reservation_duration = Range.new(reservation.check_in.to_date, reservation.check_out.to_date)
      new_reservation_duration = Range.new(self.check_in.to_date, self.check_out.to_date)
      if reservation_duration.any?(new_reservation_duration)
        errors.add(:base, 'Esse quarto já está reservado')
      end
    end
  end
  
  def invalid_date
    return if self.check_in.nil? || self.check_out.nil? 
    if self.check_in > self.check_out
      errors.add(:check_in, 'precisa ser anterior à Data de Saída')   
    end

    if self.check_in < Date.today
      errors.add(:check_in, 'no passado')
    end
  end 
end
