require 'rails_helper'

describe 'Usuário dono da pousada muda status de quarto' do
  it 'e o publica' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user, status: "draft")
    inn.rooms.create!(name: 'Quarto Economy', description: 'Quarto mais barato', area: 5, 
                      price: 100, maximum_guests: 1, has_bathroom: true, status: 'draft')               
  # Act
  login_as(user)
  visit root_path
  within 'nav' do
    click_on 'Minha pousada'
  end
  click_on 'Quarto Economy'
  click_on 'Publicar Quarto'
  # Assert
  expect(page).to have_button 'Esconder Quarto'
  expect(page).to_not have_button 'Publicar Quarto'
  end

  it 'e o esconde' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user, status: "draft")
    inn.rooms.create!(name: 'Quarto Economy', description: 'Quarto mais barato', area: 5, 
                      price: 100, maximum_guests: 1, has_bathroom: true, status: 'published')               
    # Act
    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Minha pousada'
    end
    click_on 'Quarto Economy'
    click_on 'Esconder Quarto'
    # Assert
    expect(page).to have_button 'Publicar Quarto'
    expect(page).to_not have_button 'Esconder Quarto'
  end
end