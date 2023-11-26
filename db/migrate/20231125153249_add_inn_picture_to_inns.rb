class AddInnPictureToInns < ActiveRecord::Migration[7.0]
  def change
    add_column :inns, :picture, :string
  end
end
