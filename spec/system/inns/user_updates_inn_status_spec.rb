require 'rails_helper'

describe 'Usuário dono da pousada muda status de pousada' do
  it 'e a publica' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user, status: "draft")
    # Act
    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Minha pousada'
    end
    click_on 'Publicar pousada'
    within 'header' do
      click_on 'Pousadas Rails'
    end
    # Assert
    expect(page).to have_content 'Pousada do Luar'
    expect(page).to have_content 'Cidade: Florianópolis - Santa Catarina'
  end

  it 'e a esconde' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')

    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user, status: "published")
    # Act
    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Minha pousada'
    end
    click_on 'Esconder pousada'
    within 'header' do
      click_on 'Pousadas Rails'
    end
    # Assert
    expect(page).to_not have_content 'Pousada do Luar'
    expect(page).to_not have_content 'Cidade: Florianópolis - Santa Catarina'
  end
end