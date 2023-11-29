require 'rails_helper'

describe 'Usuário vê acompanhantes da reserva' do
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
    reservation = room.reservations.create(user: guest, check_in: Time.zone.now, check_out: 14.days.from_now, 
                                           total_price: 30000, guests: 5, status: 'active') 

    reservation.reservation_guests.create!(name: 'Acompanhante 1', registration_number: 'CPF do Acompanhante 1', age: 50)
    reservation.reservation_guests.create!(name: 'Acompanhante 2', registration_number: 'CPF do Acompanhante 2', age: 65)
    reservation.reservation_guests.create!(name: 'Acompanhante 3', registration_number: 'CPF do Acompanhante 3', age: 75)
    reservation.reservation_guests.create!(name: 'Acompanhante 4', registration_number: 'CPF do Acompanhante 4', age: 24)

    # Act
    login_as(guest)
    visit root_path
    click_on 'Minhas Reservas'
    click_on reservation.code
    # Assert
    expect(page).to have_content 'Acompanhante 1'
    expect(page).to have_content 'Acompanhante 2'
    expect(page).to have_content 'Acompanhante 3'
    expect(page).to have_content 'Acompanhante 4'
    expect(page).to have_content 'CPF do Acompanhante 1'
    expect(page).to have_content 'CPF do Acompanhante 2'
    expect(page).to have_content 'CPF do Acompanhante 3'
    expect(page).to have_content 'CPF do Acompanhante 4'
    expect(page).to have_content '50'
    expect(page).to have_content '65'
    expect(page).to have_content '75'
    expect(page).to have_content '24'
    
  end
end