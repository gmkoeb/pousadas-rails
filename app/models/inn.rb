class Inn < ApplicationRecord
  extend FriendlyId
  friendly_id :brand_name, use: :slugged

  def should_generate_new_friendly_id?
    brand_name_changed?
  end

  belongs_to :user

  has_many :rooms

  validates :brand_name, :corporate_name, :registration_number, :phone, :email, 
            :address, :district, :state, :city, :zip_code, :description, 
            :payment_methods, :terms_of_service, 
            :check_in_check_out_time, presence: true

  validates :registration_number, :brand_name, :email, :phone, uniqueness: true

  validates :user_id, uniqueness: {
    message: "já possui uma pousada"
  }

  validate :user_has_admin_role

  enum status: {draft: 0, published: 2}

  private

  def user_has_admin_role
    unless user && user.admin?
      errors.add(:user, "Você precisa ser um dono de pousadas para realizar essa ação.")
    end
  end
end
