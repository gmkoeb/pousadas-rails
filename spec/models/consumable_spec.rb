require 'rails_helper'

RSpec.describe Consumable, type: :model do
  describe '#valid?' do
    it 'todos os dados estão corretos' do
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                      registration_number: '99999999999', admin: true)
      inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                    registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                    address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                    city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                    payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                    check_in_check_out_time: '12:00', user: user)
      room = inn.rooms.build(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5_000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
      special_prices = room.price_per_periods.build(special_price: 10_000, starts_at: 1.day.ago, ends_at: 4.days.from_now)
      reservation = room.reservations.build(user: user, room: room, check_in: Time.zone.now, check_out: 8.days.from_now, guests: 3, status: 'active')
      consumable = reservation.consumables.build(name: 'Coca-Cola 300ml', value: '10' )
      # Act
      result = consumable.valid?

      # Assert
      expect(result).to be true
    end
    context 'presence' do
      it 'nome em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.build(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                               price: 5_000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        special_prices = room.price_per_periods.build(special_price: 10_000, starts_at: 1.day.ago, ends_at: 4.days.from_now)
        reservation = room.reservations.build(user: user, room: room, check_in: Time.zone.now, check_out: 8.days.from_now, guests: 3, status: 'active')
        consumable = reservation.consumables.build(name: '', value: '10' )
        # Act
        consumable.valid?
        result = consumable.errors.include?(:name)
        # Assert
        expect(result).to be true
        expect(consumable.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'valor em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.build(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                               price: 5_000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        special_prices = room.price_per_periods.build(special_price: 10_000, starts_at: 1.day.ago, ends_at: 4.days.from_now)
        reservation = room.reservations.build(user: user, room: room, check_in: Time.zone.now, check_out: 8.days.from_now, guests: 3, status: 'active')
        consumable = reservation.consumables.build(name: 'Coca-Cola', value: '' )
        # Act
        consumable.valid?
        result = consumable.errors.include?(:value)
        # Assert
        expect(result).to be true
        expect(consumable.errors[:value]).to include 'não pode ficar em branco'
      end
    end
    context 'numericality' do
      it 'valor negativo' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.build(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                               price: 5_000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        special_prices = room.price_per_periods.build(special_price: 10_000, starts_at: 1.day.ago, ends_at: 4.days.from_now)
        reservation = room.reservations.build(user: user, room: room, check_in: Time.zone.now, check_out: 8.days.from_now, guests: 3, status: 'active')
        consumable = reservation.consumables.build(name: 'Coca-Cola', value: -1 )
        # Act
        consumable.valid?
        result = consumable.errors.include?(:value)
        # Assert
        expect(result).to be true
        expect(consumable.errors[:value]).to include 'deve ser maior que 0'
      end

      it 'valor nulo' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.build(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                               price: 5_000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        special_prices = room.price_per_periods.build(special_price: 10_000, starts_at: 1.day.ago, ends_at: 4.days.from_now)
        reservation = room.reservations.build(user: user, room: room, check_in: Time.zone.now, check_out: 8.days.from_now, guests: 3, status: 'active')
        consumable = reservation.consumables.build(name: 'Coca-Cola', value: 0 )
        # Act
        consumable.valid?
        result = consumable.errors.include?(:value)
        # Assert
        expect(result).to be true
        expect(consumable.errors[:value]).to include 'deve ser maior que 0'
      end
    end
  end
end
