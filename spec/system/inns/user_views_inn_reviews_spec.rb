require 'rails_helper'

describe 'Usuário vê avaliações de uma pousada' do
  it 'na página da pousada' do
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
                      check_in_check_out_time: '12:00', user: user, status: 'published')

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
    reservation_3 = room_2.reservations.create!(user: guest, check_in: 10.days.from_now, 
                                                check_out: 18.days.from_now, guests: 1, 
                                                status: 'finished')                                               
    reservation_4 = room_2.reservations.create!(user: guest, check_in: 20.days.from_now, 
                                                check_out: 28.days.from_now, guests: 1, 
                                                status: 'finished')
    review_1 = reservation_1.create_review(review_text: 'Quarto bom. Melhor pousada que fiquei na vida', 
                                           review_grade: 5, user_id: guest.id)
    review_2 = reservation_2.create_review(review_text: 'Quarto simples e barato.', 
                                           review_grade: 3, user_id: guest.id) 
    review_3 = reservation_3.create_review(review_text: 'O atendimento piorou desde a minha última estadia. Não recomendo', 
                                           review_grade: 0, user_id: guest.id)    
    review_4 = reservation_4.create_review(review_text: 'Não sei por que voltei para essa pousada. Péssimo atendimento e quarto horroroso.', 
                                           review_grade: 0, user_id: guest.id)                                        
    # Act
    visit root_path
    click_on 'Pousada do Luar', :match => :first
    # Assert
    expect(page).to have_content 'Avaliações da Pousada'
    expect(page).to have_content 'Nota Média: 2.0/5.0'
    expect(page).to have_content 'Guest'
    expect(page).to have_content 'Não sei por que voltei para essa pousada. Péssimo atendimento e quarto horroroso.'
    expect(page).to have_content 'Quarto simples e barato.'
    expect(page).to have_content 'O atendimento piorou desde a minha última estadia. Não recomendo'
    expect(page).to_not have_content 'Quarto bom. Melhor pousada que fiquei na vida'
  end

  it 'na página de avaliações' do
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
                       check_in_check_out_time: '12:00', user: user, status: 'published')

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
    reservation_3 = room_2.reservations.create!(user: guest, check_in: 10.days.from_now, 
                                                check_out: 18.days.from_now, guests: 1, 
                                                status: 'finished')                                               
    reservation_4 = room_2.reservations.create!(user: guest, check_in: 20.days.from_now, 
                                                check_out: 28.days.from_now, guests: 1, 
                                                status: 'finished')
    review_1 = reservation_1.create_review(review_text: 'Quarto bom. Melhor pousada que fiquei na vida', 
                                           review_grade: 5, user_id: guest.id)
    review_2 = reservation_2.create_review(review_text: 'Quarto simples e barato.', 
                                           review_grade: 3, user_id: guest.id) 
    review_3 = reservation_3.create_review(review_text: 'O atendimento piorou desde a minha última estadia. Não recomendo', 
                                           review_grade: 0, user_id: guest.id)    
    review_4 = reservation_4.create_review(review_text: 'Não sei por que voltei para essa pousada. Péssimo atendimento e quarto horroroso.', 
                                           review_grade: 0, user_id: guest.id)                                        
    # Act
    visit root_path
    click_on 'Pousada do Luar', :match => :first
    click_on 'Avaliações da Pousada'
    # Assert
    expect(page).to have_content 'Avaliações'
    expect(page).to have_content 'Nota Média: 2.0/5.0'
    expect(page).to have_content 'Guest'
    expect(page).to have_content 'Não sei por que voltei para essa pousada. Péssimo atendimento e quarto horroroso.'
    expect(page).to have_content 'Quarto simples e barato.'
    expect(page).to have_content 'O atendimento piorou desde a minha última estadia. Não recomendo'
    expect(page).to have_content 'Quarto bom. Melhor pousada que fiquei na vida'
  end
end