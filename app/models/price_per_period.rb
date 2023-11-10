class PricePerPeriod < ApplicationRecord
  belongs_to :room

  validates :special_price, :starts_at, :ends_at, presence:true
  
  validate :valid_inn, :date_overlaps, :invalid_date
  
  private

  def date_overlaps
    return if self.starts_at.nil? || self.ends_at.nil?
    room.price_per_periods.each do |period|
      next if period.id == id 

      range = Range.new(period.starts_at, period.ends_at)
      new_range = Range.new(self.starts_at, self.ends_at)
      overlaps = new_range.any?(range)

      errors.add(:base, 'Já existe um preço especial nessa data!') if overlaps
    end
  end

  def invalid_date
    return if self.starts_at.nil? || self.ends_at.nil? 
    errors.add(:base, 'Data de ínicio precisa ser maior que a data de término') if self.starts_at > self.ends_at  
  end 
  
  def valid_inn
    user = User.where(inn: room.inn_id).first
    unless self.room.inn && user == self.room.inn.user
      errors.add(:inn, "Essa operação não pode ser realizada.")
    end
  end
end
