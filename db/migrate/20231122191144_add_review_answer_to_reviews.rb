class AddReviewAnswerToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :review_answer, :string
  end
end
