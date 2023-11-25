require 'rails_helper'

describe 'Room API' do
  context 'GET /api/v1/inns/:inn_id/rooms' do
    it 'com sucesso' do
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                      registration_number: '99999999999')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user, status: 'published')                  
      room_1 = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                                 price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, 
                                 accessible: true, status: 'published')
      room_2 = inn.rooms.create!(name: 'Quarto Básico I', description: 'Pior quarto da pousada.', area: 5, 
                                 price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, 
                                 accessible: true, status: 'published')                         
      # Act
      get "/api/v1/inns/#{inn.id}/rooms"
      # Assert
      expect(response.status).to eq 200  
      expect(response.content_type).to include 'application/json' 
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]["name"]).to include 'Quarto Master'
      expect(json_response[1]["name"]).to include 'Quarto Básico I'
    end

    it 'e pousada não têm quartos disponíveis' do
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                      registration_number: '99999999999')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user, status: 'published')                  
      room_1 = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                                 price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, 
                                 accessible: true, status: 'draft')
      room_2 = inn.rooms.create!(name: 'Quarto Básico I', description: 'Pior quarto da pousada.', area: 5, 
                                 price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, 
                                 accessible: true, status: 'draft')                         
      # Act
      get "/api/v1/inns/#{inn.id}/rooms"
      # Assert
      expect(response.status).to eq 200  
      expect(response.content_type).to include 'application/json' 
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response).to eq []
    end

    it 'não encontra a pousada' do
      # Act
      get "/api/v1/inns/9999/rooms"
      # Assert
      expect(response.status).to eq 404  
    end
  end

  context 'POST /api/v1/rooms/:room_id/check' do
    it 'checa se quarto está disponível para reservas' do      
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                      registration_number: '99999999999')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user, status: 'published')                  
      room_1 = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                                 price: 1000, maximum_guests: 5, has_bathroom: true, has_balcony: true, 
                                 accessible: true, status: 'published')
      room_2 = inn.rooms.create!(name: 'Quarto Básico I', description: 'Pior quarto da pousada.', area: 5, 
                                 price: 5000, maximum_guests: 1, has_bathroom: true, has_balcony: true, 
                                 accessible: true, status: 'draft')    
      check_params = { reservation_details: { check_in: 8.days.from_now, check_out: 10.days.from_now, guests: 3 } }                           
      # Act
      post "/api/v1/rooms/#{room_1.id}/check", params: check_params
      # Assert
      expect(response.status).to eq 200  
      expect(response.content_type).to include 'application/json' 
      json_response = JSON.parse(response.body)
      expect(json_response["total_price"]).to eq 2000
    end

    it 'e quarto não suporta número de hóspedes' do      
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                      registration_number: '99999999999')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user, status: 'published')                  
      room_1 = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                                 price: 1000, maximum_guests: 5, has_bathroom: true, has_balcony: true, 
                                 accessible: true, status: 'published')
      room_2 = inn.rooms.create!(name: 'Quarto Básico I', description: 'Pior quarto da pousada.', area: 5, 
                                 price: 5000, maximum_guests: 1, has_bathroom: true, has_balcony: true, 
                                 accessible: true, status: 'draft')    
      check_params = { reservation_details: { check_in: 8.days.from_now, check_out: 10.days.from_now, guests: 10 } }                           
      # Act
      post "/api/v1/rooms/#{room_1.id}/check", params: check_params
      # Assert
      expect(response.status).to eq 406 
      expect(response.content_type).to include 'application/json' 
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include "Quantidade de Hóspedes acima do suportado pelo quarto" 
    end

    it 'com check in no passado' do      
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                      registration_number: '99999999999')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user, status: 'published')                  
      room_1 = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                                 price: 1000, maximum_guests: 5, has_bathroom: true, has_balcony: true, 
                                 accessible: true, status: 'published')
      room_2 = inn.rooms.create!(name: 'Quarto Básico I', description: 'Pior quarto da pousada.', area: 5, 
                                 price: 5000, maximum_guests: 1, has_bathroom: true, has_balcony: true, 
                                 accessible: true, status: 'draft')    
      check_params = { reservation_details: { check_in: 2.days.ago, check_out: 10.days.from_now, guests: 2 } }                           
      # Act
      post "/api/v1/rooms/#{room_1.id}/check", params: check_params
      # Assert
      expect(response.status).to eq 406 
      expect(response.content_type).to include 'application/json' 
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include "Data de Entrada no passado" 
    end

    it 'com check in na frente do check out' do      
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                      registration_number: '99999999999')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user, status: 'published')                  
      room_1 = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                                 price: 1000, maximum_guests: 5, has_bathroom: true, has_balcony: true, 
                                 accessible: true, status: 'published')
      room_2 = inn.rooms.create!(name: 'Quarto Básico I', description: 'Pior quarto da pousada.', area: 5, 
                                 price: 5000, maximum_guests: 1, has_bathroom: true, has_balcony: true, 
                                 accessible: true, status: 'draft')    
      check_params = { reservation_details: { check_in: 3.days.from_now, check_out: 1.day.from_now, guests: 2 } }                           
      # Act
      post "/api/v1/rooms/#{room_1.id}/check", params: check_params
      # Assert
      expect(response.status).to eq 406 
      expect(response.content_type).to include 'application/json' 
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include "Data de Entrada precisa ser anterior à Data de Saída" 
    end
  end
end