class CreateReservationGuests < ActiveRecord::Migration[7.0]
  def change
    create_table :reservation_guests do |t|
      t.string :name
      t.string :registration_number
      t.integer :age
      t.references :reservation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
