class PricePerPeriod < ApplicationRecord
  belongs_to :room

  validates :special_price, :starts_at, :ends_at, presence:true

  validate :date_overlaps

  validate :invalid_date
  
  private

  def date_overlaps
    return if starts_at.nil? || ends_at.nil?
    room.price_per_periods.each do |period|
      next if period.id == id 
      range = Range.new(period.starts_at, period.ends_at)
      new_range = Range.new(starts_at, ends_at)
      overlaps = new_range.any?(range)
      if overlaps
        errors.add(:base, 'Já existe um preço especial nessa data!')
      end
    end
  end

  def invalid_date
    return if starts_at.nil? || ends_at.nil?
    if starts_at > ends_at
      errors.add(:base, 'Data de ínicio precisa ser maior que a data de término')
    end
  end
  
end
