require 'rails_helper'

RSpec.describe PricePerPeriod, type: :model do
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
      room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                               price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
      price = room.price_per_periods.create!(special_price: 1234, starts_at: Date.today, ends_at: Date.tomorrow)
      # Act
      result = price.valid?
      # Assert
      expect(result).to eq true
    end
    context 'dates validity' do
      it 'datas sobrepostas' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        login_as(user)
        inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                                 price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        price_1 = room.price_per_periods.create!(special_price: 1234, starts_at: Date.today, ends_at: Date.tomorrow + 2)
        price_2 = room.price_per_periods.build(special_price: 12345, starts_at: Date.today + 1, ends_at: Date.tomorrow + 2)
        # Act
        result = price_2.valid?
        # Assert
        expect(result).to eq false
      end

      it 'data inicial maior que data final' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.build(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                               price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        price = room.price_per_periods.build(special_price: 1234, starts_at: Date.tomorrow, ends_at: Date.today)
        # Act
        result = price.valid?
        # Assert
        expect(result).to eq false
      end
    end
    context 'presence' do
      it 'preço especial em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.build(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                               price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        price = room.price_per_periods.build(starts_at: Date.today, ends_at: Date.tomorrow)
        # Act
        result = price.valid?
        # Assert
        expect(result).to eq false
      end

      it 'data de ínicio em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.build(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                               price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        price = room.price_per_periods.build(special_price: 1, ends_at: Date.tomorrow)
        # Act
        result = price.valid?
        # Assert
        expect(result).to eq false
      end

      it 'data de término em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.build(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                               price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        price = room.price_per_periods.build(special_price: 1, starts_at: Date.today)
        # Act
        result = price.valid?
        # Assert
        expect(result).to eq false
      end
    end
  end
end
