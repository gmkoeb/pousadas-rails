class PricePerPeriod < ApplicationRecord
  belongs_to :room

  validates :special_price, :starts_at, :ends_at, presence:true
  validates :special_price, numericality: { greater_than: 0 }
  
  validate :date_overlaps, :invalid_date
  
  private

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
end
