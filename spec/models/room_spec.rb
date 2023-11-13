require 'rails_helper'

RSpec.describe Room, type: :model do
  describe '#valid?' do
    it 'todos os dados estão corretos' do
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user)
      room = inn.rooms.build(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5)
      # Act
      result = room.valid?
      # Assert
      expect(result).to be true
    end
    context 'presence' do
      it 'nome' do
        # Arrange
        room = Room.new(description: 'Melhor quarto da pousada.', area: 50, 
                        price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        # Act
        room.valid?
        result = room.errors.include?(:name)
        # Assert
        expect(result).to be true
        expect(room.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'descrição' do
        # Arrange
        room = Room.new(name: 'Quarto Master', area: 50, 
                        price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        # Act
        room.valid?
        result = room.errors.include?(:description)
        # Assert
        expect(result).to be true
        expect(room.errors[:description]).to include 'não pode ficar em branco'
      end

      it 'area' do
        # Arrange
        room = Room.new(name: 'Quarto Master', description: 'Melhor quarto da pousada',
                        price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        # Act
        room.valid?
        result = room.errors.include?(:area)
        # Assert
        expect(result).to be true
        expect(room.errors[:area]).to include 'não pode ficar em branco'
      end

      it 'preço' do
        # Arrange
        room = Room.new(name: 'Quarto Master', description: 'Melhor quarto da pousada', area: 50,
                        maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        # Act
        room.valid?
        result = room.errors.include?(:price)
        # Assert
        expect(result).to be true
        expect(room.errors[:price]).to include 'não pode ficar em branco'
      end

      it 'número de máximo hóspedes' do
        # Arrange
        room = Room.new(name: 'Quarto Master', description: 'Melhor quarto da pousada', area: 50,
                        price: 5000, has_bathroom: true, has_balcony: true, accessible: true)
        # Act
        room.valid?
        result = room.errors.include?(:maximum_guests)
        # Assert
        expect(result).to be true
        expect(room.errors[:maximum_guests]).to include 'não pode ficar em branco'
      end
    end
  end
end
