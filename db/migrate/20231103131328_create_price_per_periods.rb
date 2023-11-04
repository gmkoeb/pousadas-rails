class CreatePricePerPeriods < ActiveRecord::Migration[7.0]
  def change
    create_table :price_per_periods do |t|
      t.integer :special_price
      t.date :starts_at
      t.date :ends_at

      t.timestamps
    end
  end
end
