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
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    user_2 = User.create!(email: 'gabriel_manika@gmail.com', password: 'password', admin: 'true')
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user, status: "published")
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
    expect(page).to have_content 'Endereço: Rua das pousadas, 114. Beira Mar Norte, Florianópolis - Santa Catarina'
    expect(page).to have_content 'Telefone para contato: 41995203040'
    expect(page).to have_content 'E-mail: pousadadoluar@gmail.com'

    expect(page).to have_content 'Pousada do Sol'
    expect(page).to have_content 'Endereço: Rua das pousadas, 124. Beira Mar Norte, Florianópolis - Santa Catarina'
    expect(page).to have_content 'Telefone para contato: 42995203040'
    expect(page).to have_content 'E-mail: pousadadosol@gmail.com'
  end

  it 'e não existem pousadas publicadas' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    user_2 = User.create!(email: 'gabriel_manika@gmail.com', password: 'password', admin: 'true')
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
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
end