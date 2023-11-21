class Room < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  belongs_to :inn
  has_many :price_per_periods
  has_many :reservations

  validates :name, :description, :area, :maximum_guests, :price, presence: true
  
  validate :valid_user, on: [:create, :update, :draft, :publish]
  validate :negative_price?

  enum status: {draft: 0, published: 2}

  private

  def valid_user
    user = User.where(inn: self.inn).first
    unless self.inn.user == user
      errors.add(:base, "Acesso negado.")
    end
  end

  def negative_price?
    return if self.price.nil?
    errors.add(:price, 'não pode ser negativo') if self.price < 0
  end
end
