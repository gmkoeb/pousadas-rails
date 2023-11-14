class AddNameAndRegistrationNumberToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :registration_number, :string
  end
end
