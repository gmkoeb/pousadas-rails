class Room < ApplicationRecord
  extend FriendlyId
  
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  belongs_to :inn

  validates :name, :description, :area, :maximum_guests, :price, presence: true

  validates :name, uniqueness:true
end
