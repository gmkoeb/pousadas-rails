class PricePerPeriod < ApplicationRecord
  belongs_to :room

  validates :special_price, :starts_at, :ends_at, presence:true
  
  validate :date_overlaps, :invalid_date, :valid_user
  validate :negative_price?
  
  private

  def valid_user
    user = User.where(inn: self.room.inn).first
    unless self.room.inn.user == user
      errors.add(:base, "Acesso negado.")
    end
  end

  def date_overlaps
    return if self.starts_at.nil? || self.ends_at.nil?
    room.price_per_periods.each do |period|
      next if period.id == id 

      range = Range.new(period.starts_at, period.ends_at)
      new_range = Range.new(self.starts_at, self.ends_at)
      errors.add(:base, 'Já existe um preço especial nessa data!') if new_range.overlaps?(range)
    end
  end

  def invalid_date
    return if self.starts_at.nil? || self.ends_at.nil? 
    errors.add(:starts_at, 'precisa ser maior que a data de término') if self.starts_at > self.ends_at  
  end 

  def negative_price?
    return if self.special_price.nil?
    errors.add(:special_price, 'não pode ser negativo') if self.special_price < 0
  end
end
