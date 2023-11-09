require 'rails_helper'

RSpec.describe Inn, type: :model do
  describe 'valid?' do
    it 'todos os dados estão corretos' do
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
      inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                    registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                    address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                    city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                    payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                    check_in_check_out_time: '12:00', user: user)
      # Act
      result = inn.valid?
      # Assert
      expect(result).to be true
    end

    context 'presence' do
      it 'com razão social em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: '', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:corporate_name)
        # Assert
        expect(result).to be true
        expect(inn.errors[:corporate_name]).to include("não pode ficar em branco")
      end

      it 'com nome fantasia em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: '', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:brand_name)
        # Assert
        expect(result).to be true
        expect(inn.errors[:brand_name]).to include("não pode ficar em branco")
      end

      it 'com CNPJ em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:registration_number)
        # Assert
        expect(result).to be true
        expect(inn.errors[:registration_number]).to include("não pode ficar em branco")
      end

      it 'com telefone em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '', email: 'pousadadoluar@gmail.com', 
                          address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:phone)
        # Assert
        expect(result).to be true
        expect(inn.errors[:phone]).to include("não pode ficar em branco")
      end

      it 'com email em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: '', 
                          address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:email)
        # Assert
        expect(result).to be true
        expect(inn.errors[:email]).to include("não pode ficar em branco")
      end

      it 'com endereço em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: '', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:address)
        # Assert
        expect(result).to be true
        expect(inn.errors[:address]).to include("não pode ficar em branco")
      end

      it 'com bairro em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Florianópolis', district: '', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:district)
        # Assert
        expect(result).to be true
        expect(inn.errors[:district]).to include("não pode ficar em branco")
      end

      it 'com estado em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Florianópolis', district: 'Beria Mar Norte', state: '',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:state)
        # Assert
        expect(result).to be true
        expect(inn.errors[:state]).to include("não pode ficar em branco")
      end

      it 'com cidade em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                          city: '', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:city)
        # Assert
        expect(result).to be true
        expect(inn.errors[:city]).to include("não pode ficar em branco")
      end

      it 'com CEP em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:zip_code)
        # Assert
        expect(result).to be true
        expect(inn.errors[:zip_code]).to include("não pode ficar em branco")
      end

      it 'com descrição em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: '',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:description)
        # Assert
        expect(result).to be true
        expect(inn.errors[:description]).to include("não pode ficar em branco")
      end
      
      it 'com formas de pagamento em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:payment_methods)
        # Assert
        expect(result).to be true
        expect(inn.errors[:payment_methods]).to include("não pode ficar em branco")
      end

      it 'com aceita pets em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: '', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:payment_methods)
        # Assert
        expect(result).to eq false
      end

      it 'com politicas de uso em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: '',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:terms_of_service)
        # Assert
        expect(result).to eq true
        expect(inn.errors[:terms_of_service]).to include("não pode ficar em branco")
      end

      it 'com horário de checkin e checkout em branco' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:check_in_check_out_time)
        # Assert
        expect(result).to eq true
        expect(inn.errors[:check_in_check_out_time]).to include("não pode ficar em branco")
      end
    end

    context 'uniqueness' do
      it 'com email repetido' do
        # Arrange
        user_1 = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        user_2 = User.new(email: 'gmkoeb2@gmail.com', password: 'password', admin: 'true')

        Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                    registration_number: '5333123', phone: '152995203040', email: 'pousadadoluar@gmail.com', 
                    address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                    city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                    payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                    check_in_check_out_time: '12:00', user: user_1)

        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar 2', 
                      registration_number: '43331233', phone: '42995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user_2)
        
        # Act
        inn.valid?
        result = inn.errors.include?(:email)
        # Assert
        expect(result).to eq true
        expect(inn.errors[:email]).to include("já está em uso")
      end
      
      it 'com nome fantasia repetido' do
        # Arrange
        user_1 = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        user_2 = User.new(email: 'gmkoeb2@gmail.com', password: 'password', admin: 'true')

        Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                    registration_number: '5333123', phone: '152995203040', email: 'pousadadoluar@gmail.com', 
                    address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                    city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                    payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                    check_in_check_out_time: '12:00', user: user_1)

        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '43331233', phone: '42995203040', email: 'pousadadoluar2@gmail.com', 
                      address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user_2)
        
        # Act
        inn.valid?
        result = inn.errors.include?(:brand_name)
        # Assert
        expect(result).to eq true
        expect(inn.errors[:brand_name]).to include("já está em uso")
      end

      it 'com CNPJ repetido' do
        # Arrange
        user_1 = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        user_2 = User.new(email: 'gmkoeb2@gmail.com', password: 'password', admin: 'true')

        Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar 2', 
                    registration_number: '43331233', phone: '152995203040', email: 'pousadadoluar@gmail.com', 
                    address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                    city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                    payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                    check_in_check_out_time: '12:00', user: user_1)

        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '43331233', phone: '42995203040', email: 'pousadadoluar2@gmail.com', 
                      address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user_2)
        
        # Act
        inn.valid?
        result = inn.errors.include?(:registration_number)
        # Assert
        expect(result).to eq true
        expect(inn.errors[:registration_number]).to include("já está em uso")
      end

      it 'com telefone repetido' do
        # Arrange
        user_1 = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        user_2 = User.new(email: 'gmkoeb2@gmail.com', password: 'password', admin: 'true')

        Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar 2', 
                    registration_number: '12345678', phone: '42995203040', email: 'pousadadoluar@gmail.com', 
                    address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                    city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                    payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                    check_in_check_out_time: '12:00', user: user_1)

        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '43331233', phone: '42995203040', email: 'pousadadoluar2@gmail.com', 
                      address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user_2)
        
        # Act
        inn.valid?
        result = inn.errors.include?(:phone)
        # Assert
        expect(result).to eq true
        expect(inn.errors[:phone]).to include("já está em uso")
      end

      it 'usuário já tem uma pousada' do
        # Arrange
        user_1 = User.new(email: 'gmkoeb2@gmail.com', password: 'password', admin: 'true')
  
        user_2 = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        Inn.create!(corporate_name: 'Pousadas Florianópolis 2 LTDA', brand_name: 'Pousada do Luar 2', 
                    registration_number: '5333123', phone: '42995203040', email: 'pousadadoluar2@gmail.com', 
                    address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                    city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                    payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                    check_in_check_out_time: '12:00', user: user_1)
  
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user_1, status: "published" )
        # Act
        inn.valid?
        result = inn.errors.include?(:user_id)
        # Assert
        expect(result).to eq true
        expect(inn.errors[:user_id]).to include("já possui uma pousada")
      end

      it 'usuário não tem uma pousada' do
        # Arrange
        user_1 = User.new(email: 'gmkoeb2@gmail.com', password: 'password', admin: 'true')

        user_2 = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        Inn.create!(corporate_name: 'Pousadas Florianópolis 2 LTDA', brand_name: 'Pousada do Luar 2', 
                    registration_number: '5333123', phone: '42995203040', email: 'pousadadoluar2@gmail.com', 
                    address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                    city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                    payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                    check_in_check_out_time: '12:00', user: user_1)

        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user_2, status: "published" )
        # Act
        result = inn.valid?
        # Assert
        expect(result).to eq true
      end
    end
    
    context 'permission' do
      it 'usuário não é dono de pousadas' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'false')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        inn.valid?
        result = inn.errors.include?(:user)
        # Assert
        expect(result).to eq true
        expect(inn.errors[:user]).to include("Você precisa ser um dono de pousadas para realizar essa ação.")
      end

      it 'usuário é dono de pousadas' do
        # Arrange
        user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
        inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Florianópolis', district: 'Beria Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                          check_in_check_out_time: '12:00', user: user)
        # Act
        result = inn.valid?
        # Assert
        expect(result).to eq true
      end
    end

 
  end

  describe '#search' do
    it 'usuário procura pousada pelo nome' do
      # Arrange
      user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Florianópolis', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                        check_in_check_out_time: '12:00', user: user, status: 'published')
      # Act
      result = Inn.search('Pousada do Luar')
      # Assert
      expect(result).to eq ([inn])
    end

    it 'usuário procura pousada pela cidade' do
      # Arrange
      user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Florianópolis', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                        check_in_check_out_time: '12:00', user: user, status: 'published')
      # Act
      result = Inn.search('florianópolis')
      # Assert
      expect(result).to eq ([inn])
    end

    it 'usuário procura pousada pelo bairro' do
      # Arrange
      user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Florianópolis', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                        check_in_check_out_time: '12:00', user: user, status: 'published')
      # Act
      result = Inn.search('beira mar')
      # Assert
      expect(result).to eq ([inn])
    end
  end

  describe '#advanced-search' do
    it 'usuário realiza busca avançada por nome' do
      # Arrange
      user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Florianópolis', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                        check_in_check_out_time: '12:00', user: user, status: 'published')
      # Act
      result = Inn.advanced_search('pousada do luar', '', '', '')
      # Assert
      expect(result).to eq ([inn])
    end
    it 'usuário busca pousadas que aceitam pets' do
      # Arrange
      user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Florianópolis', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                        check_in_check_out_time: '12:00', user: user, status: 'published')
      # Act
      result = Inn.advanced_search('', 'true', '', '')
      # Assert
      expect(result).to eq ([inn])
    end

    it 'usuário busca pousadas que não aceitam pets' do
      # Arrange
      user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Florianópolis', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                        check_in_check_out_time: '12:00', user: user, status: 'published')
      # Act
      result = Inn.advanced_search('', 'false', '', '')
      # Assert
      expect(result).to eq ([])
    end

    it 'usuário busca pousadas que aceitam pagamentos em dinheiro' do
      # Arrange
      user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Florianópolis', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                        check_in_check_out_time: '12:00', user: user, status: 'published')
      # Act
      result = Inn.advanced_search('', '', ["Dinheiro"], '')
      # Assert
      expect(result).to eq ([inn])
    end

    it 'usuário busca pousadas que aceitam todas as formas de pagamento' do
      # Arrange
      user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Florianópolis', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro, PIX, Cartão de débito, Cartão de crédito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                        check_in_check_out_time: '12:00', user: user, status: 'published')
      # Act
      result = Inn.advanced_search('', '', ["Dinheiro, PIX, Cartão de débito, Cartão de crédito"], '')
      # Assert
      expect(result).to eq ([inn])
    end

    it 'usuário busca pousadas que aceitam todas as formas de pagamento' do
      # Arrange
      user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Florianópolis', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro, PIX, Cartão de débito, Cartão de crédito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                        check_in_check_out_time: '12:00', user: user, status: 'published')
      # Act
      result = Inn.advanced_search('', '', ["Dinheiro, PIX, Cartão de débito, Cartão de crédito"], '')
      # Assert
      expect(result).to eq ([inn])
    end

    it 'usuário busca pousadas com quartos com banheiro e acessível para PCD' do
      # Arrange
      user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Florianópolis', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro, PIX, Cartão de débito, Cartão de crédito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h',
                        check_in_check_out_time: '12:00', user: user, status: 'published')
      room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                              price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)                  
      # Act
      result = Inn.advanced_search('', '', '', ['has_bathroom', 'accessible'])
      # Assert
      expect(result).to eq ([inn])
    end

  end
  describe '#sort-inns' do
    # Arrange
    it 'organiza pousadas publicadas em ordem alfabética' do
      user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
      user_2 = User.create!(email: 'gabriel_manika@gmail.com', password: 'password', admin: 'true')
      user_3 = User.create!(email: 'joao@gmail.com', password: 'password', admin: 'true')
      user_4 = User.create!(email: 'lucas@gmail.com', password: 'passsword', admin: 'true')
  
      inn_a = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'A Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user, status: 'published')
  
      inn_b = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'B Pousada do Sol', 
                          registration_number: '5333123', phone: '42995203040', email: 'pousadadosol@gmail.com', 
                          address: 'Rua das pousadas, 124', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A segunda melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user_2, status: 'published')
  
      inn_c = Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'C Pousada da Chuva', 
                          registration_number: '15333123', phone: '411203040', email: 'pousadadachuva@gmail.com', 
                          address: 'Avenida Paraná, 240', district: 'Juveve', state: 'Paraná',
                          city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                          payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user_3, status: 'published')
  
      inn_d = Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'D Pousada do Frio', 
                          registration_number: '05333123', phone: '4199511203040', email: 'pousadadofrio@gmail.com', 
                          address: 'Avenida Paraná, 100', district: 'Santa Cândida', state: 'Paraná',
                          city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                          payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user_4, status: 'published')
      # Act
      inns = Inn.all.sort_inns
      # Assert
      expect(inns.first).to eq (inn_a)
      expect(inns.second).to eq (inn_b)
      expect(inns.third).to eq (inn_c)
      expect(inns.fourth).to eq (inn_d)
    end

    it 'organiza pousadas publicadas em ordem alfabética e remove pousadas não publicadas' do
      user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
      user_2 = User.create!(email: 'gabriel_manika@gmail.com', password: 'password', admin: 'true')
      user_3 = User.create!(email: 'joao@gmail.com', password: 'password', admin: 'true')
      user_4 = User.create!(email: 'lucas@gmail.com', password: 'passsword', admin: 'true')
  
      inn_a = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'A Pousada do Luar', 
                          registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                          address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user, status: 'draft')
  
      inn_b = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'B Pousada do Sol', 
                          registration_number: '5333123', phone: '42995203040', email: 'pousadadosol@gmail.com', 
                          address: 'Rua das pousadas, 124', district: 'Beira Mar Norte', state: 'Santa Catarina',
                          city: 'Florianópolis', zip_code: '42830460', description: 'A segunda melhor pousada de Florianópolis',
                          payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user_2, status: 'published')
  
      inn_c = Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'C Pousada da Chuva', 
                          registration_number: '15333123', phone: '411203040', email: 'pousadadachuva@gmail.com', 
                          address: 'Avenida Paraná, 240', district: 'Juveve', state: 'Paraná',
                          city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                          payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user_3, status: 'published')
  
      inn_d = Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'D Pousada do Frio', 
                          registration_number: '05333123', phone: '4199511203040', email: 'pousadadofrio@gmail.com', 
                          address: 'Avenida Paraná, 100', district: 'Santa Cândida', state: 'Paraná',
                          city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                          payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                          check_in_check_out_time: '12:00', user: user_4, status: 'published')
      # Act
      inns = Inn.all.sort_inns
      # Assert
      expect(inns.first).to eq (inn_b)
      expect(inns.second).to eq (inn_c)
      expect(inns.third).to eq (inn_d)
      expect(inns).to_not include (inn_a)
    end
  end
end
