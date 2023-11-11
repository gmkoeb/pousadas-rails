require 'rails_helper'

describe 'Usuário procura pousadas' do
  it 'a partir do menu' do
    # Arrange

    # Act
    visit root_path
    # Assert
    within 'nav' do
      expect(page).to have_content 'Buscar Pousadas'
      expect(page).to have_button 'search-button'
    end
  end

  it 'e encontra pousada procurando pelo nome fantasia' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    user_2 = User.create!(email: 'gabriel_manika@gmail.com', password: 'password', admin: 'true')
    user_3 = User.create!(email: 'joao@gmail.com', password: 'password', admin: 'true')
    user_4 = User.create!(email: 'lucas@gmail.com', password: 'passsword', admin: 'true')

    inn_1 = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user, status: 'published')

    inn_2 = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Sol', 
                        registration_number: '5333123', phone: '42995203040', email: 'pousadadosol@gmail.com', 
                        address: 'Rua das pousadas, 124', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A segunda melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user_2, status: 'published')

    inn_3 = Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'Pousada da Chuva', 
                        registration_number: '15333123', phone: '411203040', email: 'pousadadachuva@gmail.com', 
                        address: 'Avenida Paraná, 240', district: 'Juveve', state: 'Paraná',
                        city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                        payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user_3, status: 'published')

    inn_4 = Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'Pousada do Frio', 
                        registration_number: '05333123', phone: '4199511203040', email: 'pousadadofrio@gmail.com', 
                        address: 'Avenida Paraná, 100', district: 'Santa Cândida', state: 'Paraná',
                        city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                        payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user_4, status: 'published')
    # Act
    visit root_path
    fill_in 'Buscar Pousadas', with: 'Pousada do Frio'
    click_on 'search-button'
    # Assert
    expect(page).to have_content 'Resultados da busca por: Pousada do Frio'
    expect(page).to have_content '1 pousada encontrada'
    expect(page).to have_link 'Pousada do Frio'
    expect(page).to have_content 'Cidade: Curitiba - Paraná.'
    expect(page).to_not have_link 'Pousada do Luar'
    expect(page).to_not have_link 'Pousada da Chuva'
    expect(page).to_not have_link 'Pousada do Sol'
  end

  it 'e encontra pousadas procurando pelo bairro' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    user_2 = User.create!(email: 'gabriel_manika@gmail.com', password: 'password', admin: 'true')
    user_3 = User.create!(email: 'joao@gmail.com', password: 'password', admin: 'true')
    user_4 = User.create!(email: 'lucas@gmail.com', password: 'passsword', admin: 'true')

    inn_1 = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user, status: 'published')

    inn_2 = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Sol', 
                        registration_number: '5333123', phone: '42995203040', email: 'pousadadosol@gmail.com', 
                        address: 'Rua das pousadas, 124', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A segunda melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user_2, status: 'published')

    inn_3 = Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'Pousada da Chuva', 
                        registration_number: '15333123', phone: '411203040', email: 'pousadadachuva@gmail.com', 
                        address: 'Avenida Paraná, 240', district: 'Juveve', state: 'Paraná',
                        city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                        payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user_3, status: 'published')

    inn_4 = Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'Pousada do Frio', 
                        registration_number: '05333123', phone: '4199511203040', email: 'pousadadofrio@gmail.com', 
                        address: 'Avenida Paraná, 100', district: 'Santa Cândida', state: 'Paraná',
                        city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                        payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user_4, status: 'published')
    # Act
    visit root_path
    fill_in 'Buscar Pousadas', with: 'beira mar'
    click_on 'search-button'
    # Assert
    expect(page).to have_content 'Resultados da busca por: beira mar'
    expect(page).to have_content '2 pousadas encontrada'
    expect(page).to have_link 'Pousada do Sol'
    expect(page).to have_content 'Cidade: Florianópolis - Santa Catarina.'
    expect(page).to have_link 'Pousada do Luar'
    expect(page).to have_content 'Cidade: Florianópolis - Santa Catarina.'
    expect(page).to_not have_link 'Pousada da Chuva'
    expect(page).to_not have_link 'Pousada do Frio'
  end

  it 'e encontra pousadas procurando pela cidade' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    user_2 = User.create!(email: 'gabriel_manika@gmail.com', password: 'password', admin: 'true')
    user_3 = User.create!(email: 'joao@gmail.com', password: 'password', admin: 'true')
    user_4 = User.create!(email: 'lucas@gmail.com', password: 'passsword', admin: 'true')

    inn_1 = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user, status: 'published')

    inn_2 = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Sol', 
                        registration_number: '5333123', phone: '42995203040', email: 'pousadadosol@gmail.com', 
                        address: 'Rua das pousadas, 124', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A segunda melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user_2, status: 'published')

    inn_3 = Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'Pousada da Chuva', 
                        registration_number: '15333123', phone: '411203040', email: 'pousadadachuva@gmail.com', 
                        address: 'Avenida Paraná, 240', district: 'Juveve', state: 'Paraná',
                        city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                        payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user_3, status: 'published')

    inn_4 = Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'Pousada do Frio', 
                        registration_number: '05333123', phone: '4199511203040', email: 'pousadadofrio@gmail.com', 
                        address: 'Avenida Paraná, 100', district: 'Santa Cândida', state: 'Paraná',
                        city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                        payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user_4, status: 'published')
    # Act
    visit root_path
    fill_in 'Buscar Pousadas', with: 'florianópolis'
    click_on 'search-button'
    # Assert
    expect(page).to have_content 'Resultados da busca por: florianópolis'
    expect(page).to have_content '2 pousadas encontrada'
    expect(page).to have_link 'Pousada do Sol'
    expect(page).to have_content 'Cidade: Florianópolis - Santa Catarina'
    expect(page).to have_link 'Pousada do Luar'
    expect(page).to have_content 'Cidade: Florianópolis - Santa Catarina'
    expect(page).to_not have_link 'Pousada da Chuva'
    expect(page).to_not have_link 'Pousada do Frio'
  end
end