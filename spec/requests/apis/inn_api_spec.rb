require 'rails_helper'

describe 'Inn API' do
  context 'GET /api/v1/inns' do
    it 'com sucesso' do
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                    registration_number: '99999999999')
      inn = Inn.create!(corporate_name: 'Pousada API LTDA', brand_name: 'Pousada da API', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadapi@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: 'Dinheiro', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user, status: 'published')
      # Act
      get "/api/v1/inns"

      # Assert
      expect(response.status).to eq 200  
      expect(response.content_type).to include 'application/json' 
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response[0]["corporate_name"]).to include('Pousada API LTDA')       
      expect(json_response[0]["brand_name"]).to include('Pousada da API')
      expect(json_response[0]["registration_number"]).to include('4333123')
      expect(json_response[0]["phone"]).to include('41995203040')
      expect(json_response[0]["email"]).to include('pousadapi@gmail.com')
      expect(json_response[0]["address"]).to include('Rua da pousada, 114')
      expect(json_response[0]["state"]).to include('Santa Catarina')
      expect(json_response[0]["city"]).to include('Florianópolis')
      expect(json_response[0]["payment_methods"]).to include('Dinheiro')
      expect(json_response[0]["accepts_pets"]).to eq true
      expect(json_response[0]["terms_of_service"]).to include('Não pode som alto após as 18h')
      expect(json_response[0]["check_in_check_out_time"]).to include('12:00')
    end

    it 'e só retorna pousadas ativas' do
      # Arrange
      user_1 = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                    registration_number: '99999999999')
      active_inn = Inn.create!(corporate_name: 'Pousada API LTDA', brand_name: 'Pousada da API', 
                               registration_number: '4333123', phone: '41995203040', email: 'pousadapi@gmail.com', 
                               address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                               city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                               payment_methods: 'Dinheiro', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                               check_in_check_out_time: '12:00', user: user_1, status: 'published')
      user_2 = User.new(email: 'user2@gmail.com', password: 'password', admin: true,
                        name: 'User2', registration_number: '99999999999')
      inactive_inn = Inn.create!(corporate_name: 'Pousada Inativa LTDA', brand_name: 'Pousada Inativa', 
                                 registration_number: '433312553', phone: '4199520304043', email: 'pousadapiinativa@gmail.com', 
                                 address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                                 city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                                 payment_methods: 'Dinheiro', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                                 check_in_check_out_time: '12:00', user: user_2, status: 'draft')                  
      # Act
      get "/api/v1/inns"

      # Assert
      expect(response.status).to eq 200  
      expect(response.content_type).to include 'application/json' 
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 1  
    end

    it 'e não existem pousadas cadastradas' do
      # Arrange
      # Act
      get "/api/v1/inns"

      # Assert
      expect(response.status).to eq 200  
      expect(response.content_type).to include 'application/json' 
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response).to eq []
    end
  end
    
  context 'GET /api/v1/inns?query=brand_name' do
    it 'filtra pousadas por nome' do
      # Arrange
      user_1 = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                        registration_number: '99999999999')
      inn_1 = Inn.create!(corporate_name: 'Pousada API LTDA', brand_name: 'Pousada da API', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadapi@gmail.com', 
                          address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: 'Dinheiro', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user_1, status: 'published')
      user_2 = User.new(email: 'user2@gmail.com', password: 'password', admin: true,
                        name: 'User2', registration_number: '99999999999')
      inn_2 = Inn.create!(corporate_name: 'Pousada Inativa LTDA', brand_name: 'Pousada Inativa', 
                          registration_number: '433312553', phone: '4199520304043', email: 'pousadapiinativa@gmail.com', 
                          address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: 'Dinheiro', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user_2, status: 'published')                  
      # Act
      get "/api/v1/inns?query=pousada da api"

      # Assert
      expect(response.status).to eq 200  
      expect(response.content_type).to include 'application/json' 
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 1  
      expect(json_response[0]["corporate_name"]).to include('Pousada API LTDA')       
      expect(json_response[0]["brand_name"]).to include('Pousada da API')
      expect(json_response[0]["registration_number"]).to include('4333123')
      expect(json_response[0]["phone"]).to include('41995203040')
      expect(json_response[0]["email"]).to include('pousadapi@gmail.com')
      expect(json_response[0]["address"]).to include('Rua da pousada, 114')
      expect(json_response[0]["state"]).to include('Santa Catarina')
      expect(json_response[0]["city"]).to include('Florianópolis')
      expect(json_response[0]["payment_methods"]).to include('Dinheiro')
      expect(json_response[0]["accepts_pets"]).to eq true
      expect(json_response[0]["terms_of_service"]).to include('Não pode som alto após as 18h')
      expect(json_response[0]["check_in_check_out_time"]).to include('12:00')
    end

    it 'não encontra nenhuma pousada' do
      # Arrange
      user_1 = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                        registration_number: '99999999999')
      inn_1 = Inn.create!(corporate_name: 'Pousada API LTDA', brand_name: 'Pousada da API', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadapi@gmail.com', 
                          address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: 'Dinheiro', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user_1, status: 'published')
      user_2 = User.new(email: 'user2@gmail.com', password: 'password', admin: true,
                        name: 'User2', registration_number: '99999999999')
      inn_2 = Inn.create!(corporate_name: 'Pousada Inativa LTDA', brand_name: 'Pousada Inativa', 
                          registration_number: '433312553', phone: '4199520304043', email: 'pousadapiinativa@gmail.com', 
                          address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: 'Dinheiro', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user_2, status: 'published')                  
      # Act
      get "/api/v1/inns?query=pousada do luar"

      # Assert
      expect(response.status).to eq 200  
      expect(response.content_type).to include 'application/json' 
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response).to eq []
    end
  end

  context 'GET /api/v1/inns/:id' do
    it 'com sucesso' do
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                    registration_number: '99999999999')
      inn = Inn.create!(corporate_name: 'Pousada API LTDA', brand_name: 'Pousada da API', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadapi@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: 'Dinheiro', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user, status: 'published')
      # Act
      get "/api/v1/inns/1"

      # Assert
      expect(response.status).to eq 200  
      expect(response.content_type).to include 'application/json' 
      json_response = JSON.parse(response.body)
      expect(json_response.keys).not_to include("corporate_name")
      expect(json_response.keys).not_to include("registration_number")  
      expect(json_response["brand_name"]).to include('Pousada da API')
      expect(json_response["phone"]).to include('41995203040')
      expect(json_response["email"]).to include('pousadapi@gmail.com')
      expect(json_response["address"]).to include('Rua da pousada, 114')
      expect(json_response["state"]).to include('Santa Catarina')
      expect(json_response["city"]).to include('Florianópolis')
      expect(json_response["payment_methods"]).to include('Dinheiro')
      expect(json_response["accepts_pets"]).to eq true
      expect(json_response["terms_of_service"]).to include('Não pode som alto após as 18h')
      expect(json_response["check_in_check_out_time"]).to include('12:00')
    end

    it 'não encontra nenhuma pousada' do
      # Arrange

      # Act
      get "/api/v1/inns/451"

      # Assert
      expect(response.status).to eq 404
    end
  end
end