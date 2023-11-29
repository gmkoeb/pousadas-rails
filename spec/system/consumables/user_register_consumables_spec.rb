require 'rails_helper'

describe 'Usuário registra item consumido pelo hóspede' do
  it 'a partir da home' do
    # Arrange
    guest = User.create!(email: 'guest@gmail.com', password: 'password', name: 'Guest',
                          registration_number: '99999999999')
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user, status: 'published')
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                              price: 1000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    reservation = room.reservations.create!(user: guest, check_in: Time.current, 
                                            check_out: 14.days.from_now, guests: 2, status: 'active') 
    
    # Act
    login_as(user)
    visit root_path
    click_on 'Reservas Ativas'
    click_on reservation.code
    click_on 'Adicionar Consumível'
    # Assert
    expect(current_path).to eq new_reservation_consumable_path(reservation)
    expect(page).to have_content 'Adicionar Consumível'
    expect(page).to have_field 'Nome do Item'
    expect(page).to have_field 'Valor'
    expect(page).to have_button 'Adicionar'
  end

  it 'com sucesso' do
    # Arrange
    guest = User.create!(email: 'guest@gmail.com', password: 'password', name: 'Guest',
                          registration_number: '99999999999')
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user, status: 'published')
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                              price: 1000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    reservation = room.reservations.create!(user: guest, check_in: Time.current, 
                                            check_out: 14.days.from_now, guests: 2, status: 'active')
    # Act
    login_as(user)
    visit new_reservation_consumable_path(reservation)
    fill_in 'Nome do Item', with: 'Pringles'
    fill_in 'Valor', with: '100'
    click_on 'Adicionar'
    # Assert
    expect(current_path).to eq reservation_path(reservation)
    expect(page).to have_content 'Consumível adicionado com sucesso'
    expect(page).to have_content 'Consumíveis'
    expect(page).to have_content 'Item'
    expect(page).to have_content 'Pringles'
    expect(page).to have_content 'Valor'
    expect(page).to have_content 'R$ 100'
  end

  it 'com dados incorretos' do
    # Arrange
    guest = User.create!(email: 'guest@gmail.com', password: 'password', name: 'Guest',
                          registration_number: '99999999999')
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user, status: 'published')
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                              price: 1000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    reservation = room.reservations.create!(user: guest, check_in: Time.current, 
                                            check_out: 14.days.from_now, guests: 2, status: 'active')
    # Act
    login_as(user)
    visit new_reservation_consumable_path(reservation)
    fill_in 'Nome do Item', with: ''
    fill_in 'Valor', with: '-100'
    click_on 'Adicionar'
    # Assert
    expect(page).to have_content 'Não foi possível adicionar consumível'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Nome do Item não pode ficar em branco'
    expect(page).to have_content 'Valor deve ser maior que 0'
  end

  it 'e reserva não está ativa' do
    # Arrange
    guest = User.create!(email: 'guest@gmail.com', password: 'password', name: 'Guest',
                          registration_number: '99999999999')
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user, status: 'published')
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                              price: 1000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    reservation = room.reservations.create!(user: guest, check_in: Time.current, 
                                            check_out: 14.days.from_now, guests: 2, status: 'canceled')
    # Act
    login_as(user)
    visit new_reservation_consumable_path(reservation)
    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Reserva deve estar ativa'
  end
end