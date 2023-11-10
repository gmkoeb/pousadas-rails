class Room < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  belongs_to :inn
  has_many :price_per_periods
  validate :valid_inn
  validates :name, :description, :area, :maximum_guests, :price, presence: true
  enum status: {draft: 0, published: 2}

  private

  def valid_inn
    user = User.where(inn: inn_id).first
    unless self.inn && user.inn == self.inn
      errors.add(:inn_id, "Essa operação não pode ser realizada.")
    end
  end
end
