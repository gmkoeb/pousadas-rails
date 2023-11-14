class AddGuestsToReservation < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :guests, :integer
  end
end
