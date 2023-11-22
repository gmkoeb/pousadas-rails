require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'valid?' do
    context 'presence' do
      it 'texto de avaliação em branco' do
        # Arrange
        user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                            registration_number: '99999999999', admin: true)
        inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                                 price: 5_000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        special_prices = room.price_per_periods.create!(special_price: 10_000, starts_at: 1.day.ago, ends_at: 4.days.from_now)
        reservation = room.reservations.create!(user: user, room: room, check_in: Time.zone.now, 
                                                check_out: 8.days.from_now, guests: 3, status: 'finished')
        review = reservation.build_review(review_text: '', review_grade: 5, user_id: user.id)
        # Act
        review.valid?
        result = review.errors.include?(:review_text)
        # Assert
        expect(result).to eq true
        expect(review.errors[:review_text]).to include 'não pode ficar em branco'
      end

      it 'nota da avaliação em branco' do
        # Arrange
        user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
        registration_number: '99999999999', admin: true)
        inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                                 price: 5_000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        special_prices = room.price_per_periods.create!(special_price: 10_000, starts_at: 1.day.ago, ends_at: 4.days.from_now)
        reservation = room.reservations.create!(user: user, room: room, check_in: Time.zone.now, 
                                                check_out: 8.days.from_now, guests: 3, status: 'finished')
        review = reservation.build_review(review_text: 'Algum texto', review_grade: '', user_id: user.id)
        # Act
        review.valid?
        result = review.errors.include?(:review_grade)
        # Assert
        expect(result).to eq true
        expect(review.errors[:review_grade]).to include 'não pode ficar em branco'
      end
    end
    context 'reservation' do   
      it 'usuário tenta fazer review em reserva não finalizada' do
        user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
        registration_number: '99999999999', admin: true)
        inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user)
        room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                                 price: 5_000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
        special_prices = room.price_per_periods.create!(special_price: 10_000, starts_at: 1.day.ago, ends_at: 4.days.from_now)
        reservation = room.reservations.create!(user: user, room: room, check_in: Time.zone.now, 
                                                check_out: 8.days.from_now, guests: 3, status: 'active')
        review = reservation.build_review(review_text: 'Texto de review', review_grade: 5, user_id: user.id)

        # Act
        review.valid?
        result = review.errors.include?(:reservation_id)
        # Assert
        expect(result).to eq true
        expect(review.errors[:reservation_id]).to include 'precisa estar finalizada para avaliar'
      end
    end
  end
end
