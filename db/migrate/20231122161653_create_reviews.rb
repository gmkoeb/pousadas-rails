class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.string :review_text
      t.integer :review_grade
      t.references :reservation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
