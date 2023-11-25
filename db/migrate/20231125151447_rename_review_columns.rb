class RenameReviewColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :reviews, :review_text, :text
    rename_column :reviews, :review_grade, :grade
    rename_column :reviews, :review_answer, :answer
  end
end
