require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'Usuário realiza check-out' do
  it 'A partir da home' do
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
    reservation = room.reservations.create(user: guest, check_in: Date.today, 
                                           check_out: 14.days.from_now, total_price: 30000, guests: 2, status: 'active') 
    
    # Act
    login_as(user)
    visit root_path
    click_on 'Reservas Ativas'
    click_on reservation.code
    click_on 'Realizar Check-Out'
    # Assert
    expect(current_path).to eq check_out_form_reservation_path(reservation)
    expect(page).to have_content 'Formulário de Check-Out'
    expect(page).to have_content 'Forma de Pagamento'
    expect(page).to have_content 'Valor Total'
    expect(page).to have_button 'Finalizar Reserva'
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
    reservation = room.reservations.create(user: guest, check_in: Date.today, 
                                           check_out: 14.days.from_now.change(hour: 12), 
                                           total_price: 30000, guests: 2, status: 'active') 
    
    # Act
    travel_to 14.days.from_now.change(hour: 11) do
      login_as(user)
      visit check_out_form_reservation_path(reservation)
      choose 'payment_method_dinheiro'
      click_on 'Finalizar Reserva'
    end
    # Assert
    expect(current_path).to eq reservation_path(reservation)
    expect(page).to have_content 'Check-Out realizado com sucesso!'
    expect(page).to have_content 'Forma de Pagamento Escolhida: Dinheiro'
    expect(page).to have_content 'Valor Total da Reserva: R$ 14000'
    expect(page).to have_content 'Status da Reserva: Finalizada'
  end

  it 'com 5 minutos de atraso' do
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
    reservation = room.reservations.create(user: guest, check_in: Date.today, 
                                           check_out: 14.days.from_now.change(hour: 12), 
                                           total_price: 30000, guests: 2, status: 'active') 
    
    # Act
    travel_to 14.days.from_now.change(hour: 12, min: 5) do
      login_as(user)
      visit check_out_form_reservation_path(reservation)
      choose 'payment_method_dinheiro'
      click_on 'Finalizar Reserva'
    end
    # Assert
    expect(current_path).to eq reservation_path(reservation)
    expect(page).to have_content 'Check-Out realizado com sucesso!'
    expect(page).to have_content 'Forma de Pagamento Escolhida: Dinheiro'
    expect(page).to have_content 'Valor Total da Reserva: R$ 15000'
    expect(page).to have_content 'Status da Reserva: Finalizada'
  end
end