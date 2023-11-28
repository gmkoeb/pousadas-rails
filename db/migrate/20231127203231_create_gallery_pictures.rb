class CreateGalleryPictures < ActiveRecord::Migration[7.0]
  def change
    create_table :gallery_pictures do |t|
      t.references :rooms, null: false, foreign_key: true
      t.references :inns, null: false, foreign_key: true
      t.string :picture

      t.timestamps
    end
  end
end
