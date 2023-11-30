require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'todos os dados corretos' do
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
        # Act
        result = reservation.valid?
        # Assert
        expect(result).to be true
      end

      it 'check_in em branco' do
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
        reservation = room.reservations.new(user: user, room: room, check_in: '', check_out: Date.tomorrow, guests: 3)
        # Act
        reservation.valid?
        result = reservation.errors.include?(:check_in)
        # Assert
        expect(result).to be true
        expect(reservation.errors[:check_in]).to include 'não pode ficar em branco'
      end

      it 'check_out em branco' do
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
        reservation = room.reservations.new(user: user, room: room, check_in: Date.today, check_out: '', guests: 3)
        # Act
        reservation.valid?
        result = reservation.errors.include?(:check_out)
        # Assert
        expect(result).to be true
        expect(reservation.errors[:check_out]).to include 'não pode ficar em branco'
      end

      it 'número de hóspedes em branco' do
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
        reservation = room.reservations.new(user: user, room: room, check_in: Date.today, check_out: Date.tomorrow, guests: '')
        # Act
        reservation.valid?
        result = reservation.errors.include?(:guests)
        # Assert
        expect(result).to be true
        expect(reservation.errors[:guests]).to include 'não pode ficar em branco'
      end
    end

    context 'datas inválidas' do
      it 'data de check-in no passado' do
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
        reservation = room.reservations.new(user: user, room: room, check_in: Time.zone.now - 2.days, check_out: 2.days.from_now, guests: 3)
        # Act
        reservation.valid?
        result = reservation.errors.include?(:check_in)
        # Assert
        expect(result).to be true
        expect(reservation.errors[:check_in]).to include 'no passado'
      end

      it 'data de check-in válida' do
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
        reservation = room.reservations.new(user: user, room: room, check_in: 2.days.from_now, check_out: 3.days.from_now, guests: 3)
        # Act
        reservation.valid?
        result = reservation.errors.include?(:check_in)
        # Assert
        expect(result).to be false
      end

      it 'data de check-in maior que data de check-out' do
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
        reservation = room.reservations.new(user: user, room: room, check_in: 3.days.from_now, check_out: 2.days.from_now, guests: 3)
        # Act
        reservation.valid?
        result = reservation.errors.include?(:check_in)
        # Assert
        expect(result).to be true
        expect(reservation.errors[:check_in]).to include 'precisa ser anterior à Data de Saída'
      end
    end

    context 'quarto' do
      it 'quarto não suporta número de hóspedes' do
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
        reservation = room.reservations.new(user: user, room: room, check_in: Date.today, check_out: Date.tomorrow, guests: 6)
        # Act
        reservation.valid?
        result = reservation.errors.include?(:guests)
        # Assert
        expect(result).to be true
        expect(reservation.errors[:guests]).to include 'acima do suportado pelo quarto'
      end

      it 'quarto suporta número de hóspedes' do
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
        reservation = room.reservations.new(user: user, room: room, check_in: Date.today, check_out: Date.tomorrow, guests: 5)
        # Act
        reservation.valid?
        result = reservation.errors.include?(:guests)
        # Assert
        expect(result).to be false
      end

      it 'quarto já está reservado com total sobreposição de datas' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
        inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                                 price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        reservation_1 = room.reservations.create!(user: user, room: room, check_in: 1.day.from_now, check_out: 7.days.from_now, guests: 5)
        reservation_2 = room.reservations.build(user: user, room: room, check_in: 2.days.from_now, check_out: 8.days.from_now, guests: 5)
        # Act
        reservation_2.valid?
        result = reservation_2.errors.include?(:base)
        # Assert
        expect(result).to be true
        expect(reservation_2.errors[:base]).to include 'Esse quarto já está reservado'
      end

      it 'quarto já está reservado com pequena sobreposição de datas' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
        inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                                 price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        reservation_1 = room.reservations.create!(user: user, room: room, check_in: 1.day.from_now, check_out: 7.days.from_now, guests: 5)
        reservation_2 = room.reservations.build(user: user, room: room, check_in: 7.days.from_now, check_out: 10.days.from_now, guests: 5)
        # Act
        reservation_2.valid?
        result = reservation_2.errors.include?(:base)
        # Assert
        expect(result).to be true
        expect(reservation_2.errors[:base]).to include 'Esse quarto já está reservado'
      end

      it 'quarto já está reservado com pequena sobreposição de datas 2' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
        inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        reservation_1 = room.reservations.create!(user: user, room: room, check_in: 4.days.from_now, check_out: 7.days.from_now, guests: 5)
        reservation_2 = room.reservations.build(user: user, room: room, check_in: 3.days.from_now, check_out: 4.days.from_now, guests: 5)
        # Act
        reservation_2.valid?
        result = reservation_2.errors.include?(:base)
        # Assert
        expect(result).to be true
        expect(reservation_2.errors[:base]).to include 'Esse quarto já está reservado'
      end

      it 'quarto não está reservado nas datas escolhidas' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
        inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                                 price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        reservation_1 = room.reservations.create!(user: user, room: room, check_in: 1.days.from_now, check_out: 7.days.from_now, guests: 5)
        reservation_2 = room.reservations.build(user: user, room: room, check_in: 8.days.from_now, check_out: 10.days.from_now, guests: 5)
        # Act
        reservation_2.valid?
        result = reservation_2.errors.include?(:base)
        # Assert
        expect(result).to be false
      end
    end
  end

  describe 'code' do
    it 'gera código aleatório ao criar nova reserva' do
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                      registration_number: '99999999999', admin: true)
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
      room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
                
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('123ABCDE')  
      reservation = room.reservations.create!(user: user, room: room, check_in: Time.zone.now, check_out: 1.day.from_now, guests: 3)
      # Act
      result = reservation.code
      
      # Assert
      expect(result).to eq '123ABCDE'
    end
  end

  describe 'calculate_price' do
    it 'sem preços especiais' do   
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
                               price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
      reservation = room.reservations.build(user: user, room: room, check_in: Time.zone.now, check_out: 1.day.from_now, guests: 3)
      consumables = []
      # Act
      result = Reservation.calculate_price(reservation.check_in, reservation.check_out, room.price, room.price_per_periods, consumables)
      # Assert
      expect(result).to eq 5000
    end

    it 'com preços especiais durante toda a estadia' do   
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
                               price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
      special_prices = room.price_per_periods.build(special_price: 10_000, starts_at: Time.current, ends_at: 10.days.from_now)
      reservation = room.reservations.build(user: user, room: room, check_in: Time.zone.now, check_out: 7.days.from_now.change(hour: 11), guests: 3)
      consumables = []
      # Act
      result = Reservation.calculate_price(reservation.check_in, reservation.check_out, room.price, room.price_per_periods, consumables)
      # Assert
      expect(result).to eq 70_000
    end

    it 'com preços especiais acabando no meio da estadia' do   
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
      reservation = room.reservations.build(user: user, room: room, check_in: Time.zone.now, check_out: 8.days.from_now, guests: 3)
      consumables = []
      # Act
      result = Reservation.calculate_price(reservation.check_in, reservation.check_out, room.price, room.price_per_periods, consumables)
      # Assert
      expect(result).to eq 60_000
    end

    it 'com itens consumidos durante estadia' do
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
      reservation.consumables.build(name: 'Coca-Cola 300ml', value: '10' )
      reservation.consumables.build(name: 'Ruffles 250g', value: '10' )
      reservation.consumables.build(name: 'Hamburger com Fritas', value: '40' )
      reservation.consumables.build(name: 'Pringles', value: '20' )
      reservation.consumables.build(name: 'Pizza grande', value: '100' )
      reservation.consumables.build(name: 'Coca-Cola 2l', value: '20' )
      # Act
      result = Reservation.calculate_price(reservation.check_in, reservation.check_out, room.price, room.price_per_periods, reservation.consumables)
      # Assert
      expect(result).to eq 60_200
    end
  end
end
