require 'rails_helper'

describe 'Usuário vê avaliações' do
  it 'da sua pousada' do
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
    review = reservation.create_review(text: 'Quarto bom. Melhor pousada que fiquei na vida', 
                                       grade: 5, user_id: guest.id)
    # Act
    login_as(user)
    visit root_path
    click_on 'Avaliações da Pousada'
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
    review = reservation.create_review(text: 'Quarto bom. Melhor pousada que fiquei na vida', 
                                       grade: 5, user_id: guest.id)
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

  it 'e é o dono da pousada avaliada' do
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

    room_1 = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                               price: 5_000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
    room_2 = inn.rooms.create!(name: 'Quarto Básico', description: 'Quarto simples e barato.', area: 10, 
                               price: 100, maximum_guests: 1)

    reservation_1 = room_1.reservations.create!(user: guest, check_in: Time.zone.now, 
                                                check_out: 8.days.from_now, guests: 3, 
                                                status: 'finished')
    reservation_2 = room_2.reservations.create!(user: guest, check_in: Time.zone.now, 
                                                check_out: 8.days.from_now, guests: 1, 
                                                status: 'finished')    

    review_1 = reservation_1.create_review(text: 'Quarto bom. Melhor pousada que fiquei na vida', 
                                           grade: 5, user_id: guest.id)
    review_2 = reservation_2.create_review(text: 'Quarto simples e barato.', 
                                           grade: 3, user_id: guest.id)                                       
    # Act
    login_as(user)
    visit reviews_path
    # Assert
    expect(page).to have_content 'Avaliações'
    expect(page).to have_link reservation_1.code
    expect(page).to have_content 'Quarto Master'
    expect(page).to have_content 'Quarto bom. Melhor pousada que fiquei na vida'
    expect(page).to have_link reservation_2.code
    expect(page).to have_content 'Quarto Básico'
    expect(page).to have_content 'Quarto simples e barato.'
  end

  it 'e não vê avaliações de outros usuários' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
    guest_1 = User.create!(email: 'guest1@gmail.com', password: 'password', name: 'Guest',
                           registration_number: '99999999999')     
    guest_2 = User.create!(email: 'guest2@gmail.com', password: 'password', name: 'Guest',
                           registration_number: '99999999999')                                    
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)

    room_1 = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                               price: 5_000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
    room_2 = inn.rooms.create!(name: 'Quarto Básico', description: 'Quarto simples e barato.', area: 10, 
                               price: 100, maximum_guests: 1)

    reservation_1 = room_1.reservations.create!(user: guest_1, check_in: Time.zone.now, 
                                                check_out: 8.days.from_now, guests: 3, 
                                                status: 'finished')
    reservation_2 = room_2.reservations.create!(user: guest_2, check_in: Time.zone.now, 
                                                check_out: 8.days.from_now, guests: 1, 
                                                status: 'finished')    

    review_1 = reservation_1.create_review(text: 'Quarto bom. Melhor pousada que fiquei na vida', 
                                           grade: 5, user_id: guest_1.id)
    review_2 = reservation_2.create_review(text: 'Quarto simples e barato.', 
                                           grade: 3, user_id: guest_2.id)                                       
    # Act
    login_as(guest_1)
    visit reviews_path
    # Assert
    expect(current_path).to eq reviews_path
    expect(page).to have_content 'Avaliações'
    expect(page).to have_link reservation_1.code
    expect(page).to have_content 'Quarto Master'
    expect(page).to have_content 'Quarto bom. Melhor pousada que fiquei na vida'
    expect(page).to_not have_link reservation_2.code
    expect(page).to_not have_content 'Quarto Básico'
    expect(page).to_not have_content 'Quarto simples e barato.'
  end
end