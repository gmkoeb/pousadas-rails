require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#admin?' do
    it 'usuário é dono de pousadas' do
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: '123456', admin: 'true')
      # Act
      result = user.admin?
      # Assert
      expect(result).to eq true
    end

    it 'usuário não é dono de pousadas' do
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: '123456', admin: 'false')
      # Act
      result = user.admin?
      # Assert
      expect(result).to eq false
    end
  end
end
