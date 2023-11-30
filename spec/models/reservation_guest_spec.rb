require 'rails_helper'

RSpec.describe ReservationGuest, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'todos os dados estão preenchidos corretamente' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.new(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        reservation = room.reservations.new(user: user, room: room, check_in: Time.current, check_out: 1.day.from_now, guests: 3)
        guest = reservation.reservation_guests.build(name: 'Acompanhante', registration_number: '13245123', age: '12')
        # Act
        result = guest.valid?
        # Assert
        expect(result).to be true
      end

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
        room = inn.rooms.new(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        reservation = room.reservations.new(user: user, room: room, check_in: Time.current, check_out: 1.day.from_now, guests: 3)
        guest = reservation.reservation_guests.build(name: '', registration_number: '13245123', age: '12')
        # Act
        guest.valid?
        result = guest.errors.include?(:name)
        # Assert
        expect(result).to be true
        expect(guest.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'cpf em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.new(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        reservation = room.reservations.new(user: user, room: room, check_in: Time.current, check_out: 1.day.from_now, guests: 3)
        guest = reservation.reservation_guests.build(name: 'Acompanhante', registration_number: '', age: '12')
        # Act
        guest.valid?
        result = guest.errors.include?(:registration_number)
        # Assert
        expect(result).to be true
        expect(guest.errors[:registration_number]).to include 'não pode ficar em branco'
      end

      it 'idade em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.new(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        reservation = room.reservations.new(user: user, room: room, check_in: Time.current, check_out: 1.day.from_now, guests: 3)
        guest = reservation.reservation_guests.build(name: 'Acompanhante', registration_number: '123123', age: '')
        # Act
        guest.valid?
        result = guest.errors.include?(:age)
        # Assert
        expect(result).to be true
        expect(guest.errors[:age]).to include 'não pode ficar em branco'
      end
    end
  end
end
