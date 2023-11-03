require 'rails_helper'
describe 'usuário vê quartos de uma pousada' do
  it 'e vê listagem de quartos' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user, status: 'published')
    inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                      price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    inn.rooms.create!(name: 'Quarto Economy', description: 'Quarto mais barato', area: 5, 
                      price: 100, maximum_guests: 1, has_bathroom: true, status: 'published')
    inn.rooms.create!(name: 'Quarto Economy Casal', description: 'Quarto mais barato para casais', area: 10, 
                      price: 200, maximum_guests: 2, has_bathroom: true, status: 'published')
    inn.rooms.create!(name: 'Quarto Master Casal', description: 'Melhor quarto para casais', area: 50, 
                      price: 6000, maximum_guests: 2, has_bathroom: true, has_balcony: true, accessible: true, status: 'draft')
    # Act
    visit root_path
    click_on 'Pousada do Luar'
    click_on 'Quartos'
    # Assert
    expect(page).to have_link 'Quarto Master'
    expect(page).to have_link 'Quarto Economy'
    expect(page).to have_link 'Quarto Economy Casal'
    expect(page).to have_content 'Quarto Master Casal'
    expect(page).to have_content 'Melhor quarto da pousada'
    expect(page).to have_content 'Quarto mais barato'
    expect(page).to have_content 'Quarto Master Casal'
    expect(page).to have_content 'Melhor quarto para casais'
    expect(page).to have_content 'Quarto indisponível no momento.'
  end

  it 'e é dono da pousada' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    login_as(user)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user, status: 'published')
    inn.rooms.create!(name: 'Quarto Master Casal', description: 'Melhor quarto para casais', area: 50, 
    price: 6000, maximum_guests: 2, has_bathroom: true, has_balcony: true, accessible: true, status: 'draft')
    # Act
    visit root_path
    within 'nav' do
      click_on 'Minha pousada'
    end
    click_on 'Quartos'
    # Assert
    expect(page).to have_link 'Quarto Master Casal'
    expect(page).to_not have_content 'Quarto indisponível no momento.'
  end
end