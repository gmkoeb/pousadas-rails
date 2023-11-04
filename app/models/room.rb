class Room < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  belongs_to :inn
 
  has_many :price_per_periods

  validates :name, :description, :area, :maximum_guests, :price, presence: true

  validates :name, uniqueness:true

  enum status: {draft: 0, published: 2}
end
