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
  def self.calculate_price(check_in, check_out, standard_price, price_per_periods)
    reservation_days = (check_out.to_date - check_in.to_date).to_i
    total_price = standard_price * reservation_days
  
    price_per_periods.each do |price_per_period|
      special_price_duration = Range.new(price_per_period.starts_at, price_per_period.ends_at)
      reservation_duration = Range.new(check_in.to_date, check_out.to_date)
  
      next unless special_price_duration.overlaps?(reservation_duration)
  
      if price_per_period.ends_at < check_out.to_date
        special_price_remaining_duration = (price_per_period.ends_at - check_in.to_date).to_i
        total_special_price = price_per_period.special_price * special_price_remaining_duration
        total_standard_price = standard_price * (check_out.to_date - price_per_period.ends_at).to_i
        total_price = total_special_price + total_standard_price
      else
        total_price = price_per_period.special_price * reservation_days
      end
    end
  
    total_price
  end
  
  def self.standardize_check_in_time(inn_time, reservation_check_in)
    return if reservation_check_in.in_time_zone.nil?

    reservation_check_in.in_time_zone.change(hour: inn_time.hour, min: inn_time.min)
  end

  def self.standardize_check_out_time(inn_time, reservation_check_out)
    return if reservation_check_out.in_time_zone.nil?
    
    reservation_check_out.in_time_zone.change(hour: inn_time.hour, min: inn_time.min)
  end

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

    if self.check_in < Time.current.to_date
      errors.add(:check_in, 'no passado')
    end
  end 
end
