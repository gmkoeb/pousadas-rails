require 'rails_helper'

describe 'Usuário vê itens consumidos durante estadia' do
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
    reservation = room.reservations.create!(user: guest, check_in: Time.current, 
                                            check_out: 14.days.from_now, guests: 2, status: 'active') 
    reservation.consumables.create!(name: 'Coca-Cola 300ml', value: '10' )
    reservation.consumables.create!(name: 'Ruffles 250g', value: '10' )
    reservation.consumables.create!(name: 'Hamburger com Fritas', value: '40' )
    reservation.consumables.create!(name: 'Pringles', value: '20' )
    reservation.consumables.create!(name: 'Pizza grande', value: '100' )
    reservation.consumables.create!(name: 'Coca-Cola 2l', value: '20' )
    # Act
    login_as(guest)
    visit root_path
    click_on 'Minhas Reservas'
    click_on reservation.code

    # Assert
    expect(page).to have_content 'Coca-Cola 300ml'
    expect(page).to have_content 'R$ 10'
    expect(page).to have_content 'Ruffles 250g'
    expect(page).to have_content 'Hamburger com Fritas'
    expect(page).to have_content 'R$ 40'
    expect(page).to have_content 'Pringles'
    expect(page).to have_content 'R$ 20'
    expect(page).to have_content 'Pizza grande'
    expect(page).to have_content 'R$ 100'
    expect(page).to have_content 'Coca-Cola 2l'
  end
end