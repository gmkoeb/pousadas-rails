require 'rails_helper'

describe 'Usuário reserva um quarto' do
  it 'a partir da home' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user, status: 'published')
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    # Act
    visit root_path
    click_on 'Pousada do Luar', :match => :first
    click_on 'Quarto Master'
    click_on 'Reservar Quarto'
    # Assert
    expect(current_path).to eq new_room_reservation_path(room)
    expect(page).to have_field 'Quantidade de Hóspedes'
    expect(page).to have_field 'Data de Entrada'
    expect(page).to have_field 'Data de Saída'
  end

  it 'e vê preço total' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user, status: 'published')
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    # Act
    visit root_path
    click_on 'Pousada do Luar', :match => :first
    click_on 'Quarto Master'
    click_on 'Reservar Quarto'
    fill_in 'Quantidade de Hóspedes', with: '5'
    fill_in 'Data de Entrada', with: Date.tomorrow
    fill_in 'Data de Saída', with: Date.tomorrow + 7
    click_on 'Verificar Disponibilidade'
    # Assert
    expect(current_path).to eq room_check_path(room)
    expect(page).to have_content 'Preço total da reserva: R$35000'
    expect(page).to have_button 'Efetuar Reserva'
  end
  
  it 'e não está autenticado' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user, status: 'published')
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    # Act
    visit root_path
    click_on 'Pousada do Luar', :match => :first
    click_on 'Quarto Master'
    click_on 'Reservar Quarto'
    fill_in 'Quantidade de Hóspedes', with: '5'
    fill_in 'Data de Entrada', with: Date.tomorrow
    fill_in 'Data de Saída', with: Date.tomorrow + 7
    click_on 'Verificar Disponibilidade'
    click_on 'Efetuar Reserva'
    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e quarto não está disponível' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user, status: 'published')
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 4, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    # Act
    visit root_path
    click_on 'Pousada do Luar', :match => :first
    click_on 'Quarto Master'
    click_on 'Reservar Quarto'
    fill_in 'Quantidade de Hóspedes', with: '5'
    fill_in 'Data de Entrada', with: Date.tomorrow
    fill_in 'Data de Saída', with: Date.tomorrow + 7
    click_on 'Verificar Disponibilidade'
    # Assert
    expect(page).to have_content('Verifique os erros abaixo:')
    expect(page).to have_content('Esse quarto não suporta essa quantidade de hóspedes')
  end
end