class AddInnToRooms < ActiveRecord::Migration[7.0]
  def change
    add_reference :rooms, :inn, null: false, foreign_key: true
  end
end
