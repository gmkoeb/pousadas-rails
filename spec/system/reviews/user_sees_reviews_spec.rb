require 'rails_helper'

describe 'Usuário vê avaliações da sua pousada' do
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
    review = reservation.create_review(review_text: 'Quarto bom. Melhor pousada que fiquei na vida', 
                                         review_grade: 5, user_id: guest.id)
    # Act
    login_as(user)
    visit root_path
    click_on 'Avaliações'
    # Assert
    expect(current_path).to eq reviews_path
    expect(page).to have_content 'Avaliações'
    expect(page).to have_link reservation.code
    expect(page).to have_content 'Quarto Master'
    expect(page).to have_content 'Quarto bom. Melhor pousada que fiquei na vida'
  end

  it 'e é o autor da avaliação' do
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
    review = reservation.create_review(review_text: 'Quarto bom. Melhor pousada que fiquei na vida', 
                                         review_grade: 5, user_id: guest.id)
    # Act
    login_as(guest)
    visit root_path
    click_on 'Minhas Avaliações'
    # Assert
    expect(current_path).to eq reviews_path
    expect(page).to have_content 'Avaliações'
    expect(page).to have_link reservation.code
    expect(page).to have_content 'Quarto Master'
    expect(page).to have_content 'Quarto bom. Melhor pousada que fiquei na vida'
  end
end