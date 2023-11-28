class CreateConsumables < ActiveRecord::Migration[7.0]
  def change
    create_table :consumables do |t|
      t.string :name
      t.integer :value
      t.references :reservation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
