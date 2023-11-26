require 'rails_helper'
describe 'Usuário responde avaliação' do
  it 'a partir da home' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
    guest = User.create!(email: 'guest@gmail.com', password: 'password', name: 'Guest',
                         registration_number: '99999999999')                    
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5_000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
    reservation = room.reservations.create!(user: guest, room: room, check_in: Time.zone.now, 
                                            check_out: 8.days.from_now, guests: 3, status: 'finished')
    review = reservation.create_review!(text: 'Quarto bom. Melhor pousada que fiquei na vida', 
                                        grade: 5, user_id: guest.id)
    # Act
    login_as(user)
    visit root_path
    click_on 'Avaliações'
    click_on reservation.code
    # Assert
    expect(current_path).to eq reservation_path(reservation)
    expect(page).to have_content 'Responder Avaliação'
    expect(page).to have_field 'Resposta'
    expect(page).to have_button 'Enviar Resposta'
  end

  it 'com sucesso' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
    guest = User.create!(email: 'guest@gmail.com', password: 'password', name: 'Guest',
                         registration_number: '99999999999')                    
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5_000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
    reservation = room.reservations.create!(user: guest, room: room, check_in: Time.zone.now, 
                                            check_out: 8.days.from_now, guests: 3, status: 'finished')
    review = reservation.create_review!(text: 'Quarto bom. Melhor pousada que fiquei na vida', 
                                        grade: 5, user_id: guest.id)
    # Act
    login_as(user)
    visit reservation_path(reservation)
    fill_in 'Resposta', with: 'Obrigado pela sua avaliação'
    click_on 'Enviar Resposta'
    # Assert
    expect(current_path).to eq reservation_path(reservation)
    expect(page).to have_content 'Resposta enviada com sucesso'
    expect(page).to have_content 'Resposta da Pousada'
    expect(page).to have_content 'Obrigado pela sua avaliação'
  end
end