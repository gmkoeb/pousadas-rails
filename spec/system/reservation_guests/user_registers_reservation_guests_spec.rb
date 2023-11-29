require 'rails_helper'
describe 'Usuário cadastra acompanhantes da reserva' do
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
                            price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    reservation = room.reservations.create(user: guest, check_in: Time.zone.now, check_out: 14.days.from_now, total_price: 30000, guests: 3) 
    
    # Act
    login_as(user)
    visit root_path
    click_on 'Reservas'
    click_on reservation.code
    click_on 'Iniciar Processo de Check-in'
    # Assert
    expect(current_path).to eq check_in_form_reservation_path(reservation)
    expect(page).to have_content 'Processo de Check-in'
    expect(page).to have_content 'Acompanhante 1'
    expect(page).to have_content 'Acompanhante 2'
    expect(page).to have_field 'Nome Completo'
    expect(page).to have_field 'CPF'
    expect(page).to have_field 'Idade'
    expect(page).to have_button 'Registrar Acompanhantes'
    expect(page).to_not have_button 'Efetuar Check-in'
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
                            price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    reservation = room.reservations.create(user: guest, check_in: Time.zone.now, check_out: 14.days.from_now, total_price: 30000, guests: 2) 
    
    # Act
    login_as(user)
    visit check_in_form_reservation_path(reservation)
    fill_in 'Nome Completo', with: 'Acompanhante 1'
    fill_in 'CPF', with: '1234567'
    fill_in 'Idade', with: '26'
    click_on 'Registrar Acompanhantes'
    # Assert
    expect(page).to have_content 'Hóspedes acompanhantes cadastrados com sucesso!'
    expect(page).to have_button 'Efetuar Check-in'
  end

  it 'e não existem acompanhantes na reserva' do
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
                            price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    reservation = room.reservations.create(user: guest, check_in: Time.zone.now, check_out: 14.days.from_now, total_price: 30000, guests: 1) 
    
    # Act
    login_as(user)
    visit reservation_path(reservation)
    # Assert
    expect(page).to_not have_button 'Iniciar Processo de Check-in'
    expect(page).to have_button 'Efetuar Check-in'
  end
end