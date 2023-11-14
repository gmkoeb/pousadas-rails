require 'rails_helper'

describe 'Usuário não autenticado visita página inicial' do
  it 'e vê a logo da aplicação' do
    # Arrange

    # Act
    visit root_path
    # Assert
    expect(page).to have_link 'Pousadas Rails'
  end

  it 'e vê o botão de entrar' do
    # Arrange

    # Act
    visit root_path
    # Assert
    within 'nav' do
      expect(page).to have_content 'Entrar'
    end
  end

  it 'e vê as pousadas publicadas' do 
    # Arrange 
    user_1 = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                          registration_number: '99999999999', admin: true)
    user_2 = User.create!(email: 'gmkoeb2@gmail.com', password: 'password', name: 'Gabriel', 
                          registration_number: '99999999999', admin: true)

    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user_1, status: "published")
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Sol', 
                      registration_number: '5333123', phone: '42995203040', email: 'pousadadosol@gmail.com', 
                      address: 'Rua das pousadas, 124', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A segunda melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user_2, status: "published")
    # Act
    visit root_path
    # Assert
    expect(page).to have_content 'Pousada do Luar'
    expect(page).to have_content 'Florianópolis - Santa Catarina'

    expect(page).to have_content 'Pousada do Sol'
    expect(page).to have_content 'Florianópolis - Santa Catarina'
  end

  it 'e não existem pousadas publicadas' do
    # Arrange
    user_1 = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                            registration_number: '99999999999', admin: true)
    user_2 = User.create!(email: 'gmkoeb2@gmail.com', password: 'password', name: 'Gabriel', 
                          registration_number: '99999999999', admin: true)

    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user_1)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Sol', 
                      registration_number: '5333123', phone: '42995203040', email: 'pousadadosol@gmail.com', 
                      address: 'Rua das pousadas, 124', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A segunda melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user_2)
    # Act
    visit root_path
    # Assert
    expect(page).to have_content 'Ainda não existem pousadas cadastradas.'
  end

  it 'e vê as três pousadas mais recentes publicadas' do
    # Arrange
    user_1 = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                            registration_number: '99999999999', admin: true)
    user_2 = User.create!(email: 'gmkoeb2@gmail.com', password: 'password', name: 'Gabriel', 
                          registration_number: '99999999999', admin: true)
    user_3 = User.create!(email: 'joao@gmail.com', password: 'password', name: 'Joao', 
                          registration_number: '99999999999', admin: true)

    Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user_1, status: 'published')

    Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Sol', 
                registration_number: '5333123', phone: '42995203040', email: 'pousadadosol@gmail.com', 
                address: 'Rua das pousadas, 124', district: 'Beira Mar Norte', state: 'Santa Catarina',
                city: 'Florianópolis', zip_code: '42830460', description: 'A segunda melhor pousada de Florianópolis',
                payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user_2, status: 'published')

    Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'Pousada da Chuva', 
                registration_number: '15333123', phone: '411203040', email: 'pousadadochuva@gmail.com', 
                address: 'Avenida Paraná, 240', district: 'Juveve', state: 'Paraná',
                city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user_3, status: 'published')
    # Act
    visit root_path
    # Assert
    expect(page).to have_content 'Pousadas Mais Recentes'
    expect(page).to have_link 'Pousada do Luar'
    expect(page).to have_link 'Pousada do Sol'
    expect(page).to have_link 'Pousada da Chuva'
    expect(page).to have_content 'Florianópolis - Santa Catarina'
    expect(page).to have_content 'Florianópolis - Santa Catarina'
    expect(page).to have_content 'Curitiba - Paraná'
  end

  it 'e vê as pousadas mais antigas publicadas separadamente' do
    # Arrange
    user_1 = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                            registration_number: '99999999999', admin: true)
    user_2 = User.create!(email: 'gmkoeb2@gmail.com', password: 'password', name: 'Gabriel', 
                          registration_number: '99999999999', admin: true)
    user_3 = User.create!(email: 'joao@gmail.com', password: 'password', name: 'Joao', 
                          registration_number: '99999999999', admin: true)
    user_4 = User.create!(email: 'lucas@gmail.com', password: 'passsword', name: 'Lucas', 
                          registration_number: '99999999999', admin: true)

    Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user_1, status: 'published')

    Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Sol', 
                registration_number: '5333123', phone: '42995203040', email: 'pousadadosol@gmail.com', 
                address: 'Rua das pousadas, 124', district: 'Beira Mar Norte', state: 'Santa Catarina',
                city: 'Florianópolis', zip_code: '42830460', description: 'A segunda melhor pousada de Florianópolis',
                payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user_2, status: 'published')

    Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'Pousada da Chuva', 
                registration_number: '15333123', phone: '411203040', email: 'pousadadachuva@gmail.com', 
                address: 'Avenida Paraná, 240', district: 'Juveve', state: 'Paraná',
                city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user_3, status: 'published')

    Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'Pousada do Frio', 
                registration_number: '05333123', phone: '4199511203040', email: 'pousadadofrio@gmail.com', 
                address: 'Avenida Paraná, 100', district: 'Santa Cândida', state: 'Paraná',
                city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user_4, status: 'published')

    # Act
    visit root_path
    # Assert
    expect(page).to have_content 'Pousadas Mais Recentes'
    expect(page).to have_link 'Pousada do Luar'
    expect(page).to have_link 'Pousada do Sol'
    expect(page).to have_link 'Pousada da Chuva'
    expect(page).to have_content 'Florianópolis - Santa Catarina'
    expect(page).to have_content 'Florianópolis - Santa Catarina'
    expect(page).to have_content 'Curitiba - Paraná'
    expect(page).to have_content 'Pousada'
    expect(page).to have_link 'Pousada do Frio'
    expect(page).to have_content 'Curitiba - Paraná'
  end

  it 'e vê lista de cidades' do
    # Arrange
    user_1 = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                            registration_number: '99999999999', admin: true)
    user_2 = User.create!(email: 'gmkoeb2@gmail.com', password: 'password', name: 'Gabriel', 
                          registration_number: '99999999999', admin: true)
    user_3 = User.create!(email: 'joao@gmail.com', password: 'password', name: 'Joao', 
                          registration_number: '99999999999', admin: true)
    user_4 = User.create!(email: 'lucas@gmail.com', password: 'passsword', name: 'Lucas', 
                          registration_number: '99999999999', admin: true)

    Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user_1, status: 'published')

    Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Sol', 
                registration_number: '5333123', phone: '42995203040', email: 'pousadadosol@gmail.com', 
                address: 'Rua das pousadas, 124', district: 'Beira Mar Norte', state: 'Santa Catarina',
                city: 'Florianópolis', zip_code: '42830460', description: 'A segunda melhor pousada de Florianópolis',
                payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user_2, status: 'published')

    Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'Pousada da Chuva', 
                registration_number: '15333123', phone: '411203040', email: 'pousadadachuva@gmail.com', 
                address: 'Avenida Paraná, 240', district: 'Juveve', state: 'Paraná',
                city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user_3, status: 'published')

    Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'Pousada do Frio', 
                registration_number: '05333123', phone: '4199511203040', email: 'pousadadofrio@gmail.com', 
                address: 'Avenida Paraná, 100', district: 'Santa Cândida', state: 'Paraná',
                city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user_4, status: 'published')

    # Act
    visit root_path
    # Assert
    expect(page).to have_content 'Cidades com Pousadas'
    expect(page).to have_link 'Curitiba'
    expect(page).to have_link 'Florianópolis'
  end
end