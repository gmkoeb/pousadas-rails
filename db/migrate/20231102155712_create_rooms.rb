class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :description
      t.integer :area
      t.integer :maximum_guests
      t.integer :price
      t.boolean :has_bathroom
      t.boolean :has_balcony
      t.boolean :has_air_conditioner
      t.boolean :has_tv
      t.boolean :has_wardrobe
      t.boolean :has_coffer
      t.boolean :accessible

      t.timestamps
    end
  end
end
