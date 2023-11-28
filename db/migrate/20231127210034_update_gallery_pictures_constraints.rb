class UpdateGalleryPicturesConstraints < ActiveRecord::Migration[7.0]
  def change
    rename_column :gallery_pictures, :rooms_id, :room_id
    rename_column :gallery_pictures, :inns_id, :inn_id
  end
end
