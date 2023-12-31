class Reservation < ApplicationRecord
  extend FriendlyId
  friendly_id :code, use: :slugged

  belongs_to :user, optional: true
  belongs_to :room

  has_one :review
  has_many :consumables
  has_many :reservation_guests

  validates :guests, :check_in, :check_out, presence: true
  validates :guests, numericality: { greater_than: 0 }

  validate :room_supports_guests
  validate :invalid_date, on: :create
  validate :room_is_reserved, on: :create

  before_validation :generates_code, on: :create

  enum status: {pending: 0, active: 2, canceled: 4, finished: 6}
  
  private

  def self.calculate_price(check_in, check_out, standard_price, price_per_periods, consumables)
    return if check_in.nil? || check_out.nil?
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
    
    if consumables.any?
      consumables_price = 0
      consumables.each do |consumable|
        consumables_price += consumable.value
      end
      total_price += consumables_price
    end
    total_price
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
    active_reservations = room.reservations.not_canceled.not_finished
    active_reservations.each do |reservation|
      reservation_duration = Range.new(reservation.check_in.to_date, reservation.check_out.to_date)
      new_reservation_duration = Range.new(self.check_in.to_date, self.check_out.to_date)

      errors.add(:base, 'Esse quarto já está reservado') if new_reservation_duration.overlaps?(reservation_duration)
      
    end
  end
  
  def invalid_date
    return if self.check_in.nil? || self.check_out.nil? 
    if self.check_in > self.check_out
      errors.add(:check_in, 'precisa ser anterior à Data de Saída')   
    end

    if self.check_in < Time.zone.now.to_date
      errors.add(:check_in, 'no passado')
    end
  end 
end
