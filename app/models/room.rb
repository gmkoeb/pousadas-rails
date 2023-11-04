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

  validate :belongs_to_correct_inn

  private

  def belongs_to_correct_inn
    if inn_id && inn_id != inn.id
      errors.add(:base, "Essa ação não pode ser realizada.")
    end
  end
  
end
