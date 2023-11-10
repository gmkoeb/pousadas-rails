require 'rails_helper'

describe 'Usuário realiza busca avançada' do
  it 'a partir do menu de navegação' do
    # Assert

    # Act
    visit root_path
    click_on 'busca avançada'
    # Arrange
    expect(page).to have_content "Busca Avançada de Pousadas"
    expect(page).to have_content "Pousada"
    expect(page).to have_content "Aceita Pets"
    expect(page).to have_content "Dinheiro"
    expect(page).to have_content "PIX"
    expect(page).to have_content "Cartão de débito"
    expect(page).to have_content "Cartão de crédito"
    expect(page).to have_content "Possui quarto com banheiro próprio"
    expect(page).to have_content "Possui quarto com varanda"
    expect(page).to have_content "Possui quarto ar condicionado"
    expect(page).to have_content "Possui quarto com TV"
    expect(page).to have_content "Possui quarto com armário"
    expect(page).to have_content "Possui quarto acessível para pessoas com deficiência"
    expect(page).to have_content "Aceita Pets?"
  end

  it 'com sucesso' do
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
    click_on 'busca avançada'
    within 'main form' do
      fill_in 'Pousada', with: 'Pousada do Frio'
      click_on 'Busca Avançada'
    end
    # Assert
    expect(page).to have_content 'Busca Avançada'
    expect(page).to have_content '1 pousada encontrada'
    expect(page).to have_link 'Pousada do Frio'
    expect(page).to have_content 'Cidade: Curitiba - Paraná.'
    expect(page).to_not have_link 'Pousada do Luar'
    expect(page).to_not have_link 'Pousada da Chuva'
    expect(page).to_not have_link 'Pousada do Sol'
  end
end