require 'rails_helper'
describe 'Usuário visita página de cidade' do
  it 'e vê pousadas publicadas da cidade' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    user_2 = User.create!(email: 'gabriel_manika@gmail.com', password: 'password', admin: 'true')
    user_3 = User.create!(email: 'joao@gmail.com', password: 'password', admin: 'true')
    user_4 = User.create!(email: 'lucas@gmail.com', password: 'passsword', admin: 'true')
    user_5 = User.create!(email: 'andré@gmail.com', password: 'passsword', admin: 'true')

    Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user, status: 'published')

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

    Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'Pousada do Frio Não Publicada', 
                registration_number: '053331234', phone: '41995112030404', email: 'pousadadofrio2@gmail.com', 
                address: 'Avenida Paraná, 100', district: 'Santa Cândida', state: 'Paraná',
                city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user_5, status: 'draft')            

    # Act
    visit root_path
    click_on 'Curitiba'
    # Assert
    expect(page).to have_content 'Pousadas em Curitiba'
    expect(page).to have_link 'Pousada da Chuva'
    expect(page).to have_link 'Pousada do Frio'
    expect(page).to_not have_link 'Pousada do Luar'
    expect(page).to_not have_link 'Pousada do Sol'
    expect(page).to_not have_link 'Pousada do Frio Não Publicada'
  end

  it 'e vê detalhes de uma pousada' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')

    Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'Pousada da Chuva', 
                registration_number: '15333123', phone: '411203040', email: 'pousadadachuva@gmail.com', 
                address: 'Avenida Paraná, 240', district: 'Juveve', state: 'Paraná',
                city: 'Curitiba', zip_code: '82830460', description: 'A melhor pousada de Curitiba!',
                payment_methods: '["Dinheiro, PIX, Cartão de crédito, Cartão de débito"]', accepts_pets: 'true', terms_of_service: 'Proibido som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user, status: 'published')

    # Act
    visit root_path
    click_on 'Curitiba'
    click_on 'Pousada da Chuva'
    # Assert
    expect(page).to have_content 'Pousada da Chuva'
    expect(page).to have_content 'Detalhes da pousada'
    expect(page).to have_content 'Telefone para contato: 411203040'
    expect(page).to have_content 'E-mail: pousadadachuva@gmail.com'
    expect(page).to have_content 'Endereço completo: Avenida Paraná, 240. Juveve, Curitiba - Paraná'
    expect(page).to have_content 'CEP: 82830460'
    expect(page).to have_content 'Descrição: A melhor pousada de Curitiba!'
    expect(page).to have_content 'Formas de pagamento'
    expect(page).to have_content 'Dinheiro'
    expect(page).to have_content 'PIX'
    expect(page).to have_content 'Cartão de crédito'
    expect(page).to have_content 'Cartão de débito'
    expect(page).to have_content 'Essa pousada permite pets'
    expect(page).to have_content 'Políticas de uso: Proibido som alto após as 18h'
    expect(page).to have_content 'Horário padrão para check-in e check-out: 12:00'
    expect(page).to_not have_link 'Editar'
    expect(page).to_not have_button 'Esconder pousada'
  end
end