class ChangeGalleryPicturesConstraints < ActiveRecord::Migration[7.0]
  def change
    change_column :gallery_pictures, :rooms_id, :integer, null: true
    change_column :gallery_pictures, :inns_id, :integer, null: true
  end
end
