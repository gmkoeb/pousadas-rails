class AddRoomsToPricePerPeriod < ActiveRecord::Migration[7.0]
  def change
    add_reference :price_per_periods, :rooms, null: false, foreign_key: true
  end
end
