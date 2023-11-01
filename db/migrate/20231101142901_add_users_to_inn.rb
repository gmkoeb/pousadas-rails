class AddUsersToInn < ActiveRecord::Migration[7.0]
  def change
    add_reference :inns, :user, null: false, foreign_key: true
  end
end
