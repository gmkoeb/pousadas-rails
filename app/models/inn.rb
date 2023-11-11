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
    unless self.user && self.user.admin?
      errors.add(:user, "Você precisa ser um dono de pousadas para realizar essa ação.")
    end
  end

  def self.sort_inns
    self.published.sort_by { |inn| inn[:brand_name] }
  end

  def self.search(query)
    self.where("brand_name LIKE ? OR city LIKE ? OR district LIKE ?", 
                         "%#{query}%", "%#{query}%", "%#{query}%").sort_inns
  end
  
  def self.advanced_search(query, accepts_pets, payment_methods, room_infos, room_maximum_guests, room_price)
    inns = Inn.all
    inns = inns.where("brand_name LIKE ? OR city LIKE ? OR district LIKE ?", 
                      "%#{query}%", "%#{query}%", "%#{query}%") if query.present?
    inns = inns.where(accepts_pets: true) if accepts_pets == 'true'
    inns = inns.where(accepts_pets: false) if accepts_pets == 'false'

    if payment_methods.present?
      payment_methods.each do |payment_method|
        inns = inns.where("payment_methods LIKE ?", "%#{payment_method}%" )
      end
    end

    if room_infos.present?
      room_conditions = room_infos.map { |info| "rooms.#{info} = true" }
      inn_ids_with_matching_rooms = Inn.joins(:rooms)
                                       .where(room_conditions.join(' AND '))
                                       .distinct
                                       .pluck(:id)
    
      inns = inns.where(id: inn_ids_with_matching_rooms)
    end 

    inns = inns.joins(:rooms).where("maximum_guests >= #{room_maximum_guests}") if room_maximum_guests.present?

    inns = inns.joins(:rooms).where("price <= #{room_price}") if room_price.present?
    
    return inns.sort_inns
  end 
end
