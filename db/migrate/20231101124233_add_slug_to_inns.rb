class AddSlugToInns < ActiveRecord::Migration[7.0]
  def change
    add_column :inns, :slug, :string
    add_index :inns, :slug, unique: true
  end
end
