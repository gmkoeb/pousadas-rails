require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'Usuário realiza check-in' do
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
    visit root_path
    click_on 'Reservas'
    click_on reservation.code
    click_on 'Realizar Check-in'
    # Assert
    expect(current_path).to eq reservation_path(reservation)
    expect(page).to have_content 'Check-in realizado com sucesso!'
    expect(page).to have_content 'Status da Reserva: Ativa'
  end
  
  it 'dois dias após data prevista' do
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
    reservation = room.reservations.create!(user: guest, check_in: 1.days.from_now.change(hour: 12), 
                                            check_out: 14.days.from_now, total_price: 30000, guests: 2) 
    
    # Act
    travel_to 3.days.from_now.change(hour: 13) do
      login_as(user)
      visit reservation_path(reservation)
      click_on 'Realizar Check-in'
    end
    # Assert
    expect(current_path).to eq reservation_path(reservation)
    expect(page).to have_content 'Não foi possível realizar o check-in.'
    expect(page).to have_content 'Status da Reserva: Pendente'
  end

  it 'antes da data prevista' do
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
    reservation = room.reservations.create!(user: guest, check_in: 1.days.from_now.change(hour: 12), 
                                            check_out: 14.days.from_now, total_price: 30000, guests: 2) 
    
    # Act
    login_as(user)
    visit reservation_path(reservation)
    click_on 'Realizar Check-in'

    # Assert
    expect(current_path).to eq reservation_path(reservation)
    expect(page).to have_content 'Não foi possível realizar o check-in.'
    expect(page).to have_content 'Status da Reserva: Pendente'
  end
end