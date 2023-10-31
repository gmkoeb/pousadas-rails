class CreateInns < ActiveRecord::Migration[7.0]
  def change
    create_table :inns do |t|
      t.string :corporate_name
      t.string :brand_name
      t.string :registration_number
      t.string :phone
      t.string :email
      t.string :address
      t.string :district
      t.string :state
      t.string :city
      t.string :zip_code
      t.string :description
      t.string :payment_methods
      t.boolean :accepts_pets
      t.string :terms_of_service
      t.time :check_in_check_out_time

      t.timestamps
    end
  end
end
