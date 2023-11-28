class Room < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end
  has_one_attached :picture
  belongs_to :inn
  has_many :price_per_periods
  has_many :reservations
  has_many :gallery_pictures
  validates :name, :description, :area, :maximum_guests, :price, presence: true

  validate :negative_price?
  validate :picture_format
  
  enum status: {draft: 0, published: 2}

  delegate :check_in_check_out_time, :payment_methods, to: :inn

  private

  def negative_price?
    return if self.price.nil?
    errors.add(:price, 'não pode ser negativo') if self.price < 0
  end

  def picture_format
    if picture.attached? && !picture.content_type.in?(%w(image/jpeg image/png))
      errors.add(:picture, 'deve possuir extensão JPEG ou PNG')
    end
  end
end
