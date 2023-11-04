class ChangeRoomsIdToRoomId < ActiveRecord::Migration[7.0]
  def change
    rename_column :price_per_periods, :rooms_id, :room_id
  end
end
