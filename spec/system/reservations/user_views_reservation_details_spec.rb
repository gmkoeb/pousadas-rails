require 'rails_helper'
describe 'Usuário checa detalhes de reserva' do
  it 'e reserva foi finalizada' do
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
    reservation = room.reservations.create!(user: guest, check_in: 8.days.from_now.at_midday, check_out: 14.days.from_now.at_midday, 
                                            total_price: 30000, guests: 2, status: 'finished') 
    # Act
    login_as guest
    visit root_path
    click_on 'Minhas Reservas'
    click_on reservation.code
    # Assert
    expect(page).to have_content "Reserva #{reservation.code}" 
    expect(page).to have_content "Status da Reserva: Finalizada"
    expect(page).to have_content "Quarto Reservado: Quarto Master"
    expect(page).to have_content "Data de Entrada: #{I18n.localize(8.days.from_now.at_midday.in_time_zone('America/Sao_Paulo'), format: :no_timezone)}"
    expect(page).to have_content "Data de Saída: #{I18n.localize(14.days.from_now.at_midday.in_time_zone('America/Sao_Paulo'), format: :no_timezone)}"
    expect(page).to have_content "Valor Total da Reserva: R$ 30000"
  end

  it 'e reserva foi cancelada' do
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
    reservation = room.reservations.create!(user: guest, check_in: 8.days.from_now.at_midday, check_out: 14.days.from_now.at_midday, 
                                            total_price: 30000, guests: 2, status: 'canceled') 
    # Act
    login_as guest
    visit reservation_path(reservation)
    # Assert
    expect(page).to have_content "Reserva #{reservation.code}" 
    expect(page).to have_content "Status da Reserva: Cancelada"
    expect(page).to have_content "Quarto Reservado: Quarto Master"
    expect(page).to have_content "Data do cancelamento: #{I18n.localize(Time.current.to_date)}"
  end

  context 'e dono da pousada' do
    it 'vê reserva que está pendente' do
      # Arrange
      guest = User.create!(email: 'guest@gmail.com', password: 'password', name: 'Guest',
                           registration_number: '99999999999')
      admin = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                          registration_number: '99999999999', admin: true)
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: admin, status: 'published')
      room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                               price: 1000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
      reservation = room.reservations.create!(user: guest, check_in: 1.day.from_now.at_midday, check_out: 14.days.from_now.at_midday, 
                                              total_price: 13000, guests: 2, status: 'pending') 
      # Act
      login_as admin
      visit root_path
      click_on 'Reservas'
      click_on reservation.code
      # Assert
      expect(page).to have_content "Reserva #{reservation.code}" 
      expect(page).to have_content "Status da Reserva: Pendente"
      expect(page).to have_content "Informações de reserva para o quarto: Quarto Master"
      expect(page).to have_content "Data de Entrada: #{I18n.localize(1.days.from_now.at_midday, format: :no_timezone)}"
      expect(page).to have_content "Data de Saída: #{I18n.localize(14.days.from_now.at_midday, format: :no_timezone)}"
      expect(page).to have_content "Horário de check-in e check-out: 12:00"
      expect(page).to have_content "Formas de pagamento aceitas:"
      expect(page).to have_content "Dinheiro"
      expect(page).to have_content "Valor total das diárias: R$13000"
      expect(page).to have_button "Cancelar Reserva"
      expect(page).to have_button "Iniciar Processo de Check-in"
    end

    it 'vê reserva que está ativa' do
      # Arrange
      guest = User.create!(email: 'guest@gmail.com', password: 'password', name: 'Guest',
                           registration_number: '99999999999')
      admin = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                          registration_number: '99999999999', admin: true)
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: admin, status: 'published')
      room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                               price: 1000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
      reservation = room.reservations.create!(user: guest, check_in: 1.day.from_now.at_midday, check_out: 14.days.from_now.at_midday, 
                                              total_price: 13000, guests: 2, status: 'active') 
      # Act
      login_as admin
      visit root_path
      click_on 'Reservas Ativas'
      click_on reservation.code
      # Assert
      expect(page).to have_content "Reserva #{reservation.code}" 
      expect(page).to have_content "Status da Reserva: Ativa"
      expect(page).to have_content "Quarto Reservado: Quarto Master"
      expect(page).to have_content "Data de Entrada: #{I18n.localize(1.days.from_now.at_midday.in_time_zone('America/Sao_Paulo'), format: :no_timezone)}"
      expect(page).to have_content "Data de Saída: #{I18n.localize(14.days.from_now.at_midday, format: :no_timezone)}"
      expect(page).to have_link "Realizar Check-Out"
    end
  end
  
  context 'e hóspede' do
    it 'vê reserva que está pendente com data de check-in muito próxima' do
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
      reservation = room.reservations.create!(user: guest, check_in: 1.day.from_now.at_midday, check_out: 14.days.from_now.at_midday, 
                            total_price: 13000, guests: 2, status: 'pending') 
      # Act
      login_as guest
      visit reservation_path(reservation)
      # Assert
      expect(page).to have_content "Reserva #{reservation.code}" 
      expect(page).to have_content "Status da Reserva: Pendente"
      expect(page).to have_content "Informações de reserva para o quarto: Quarto Master"
      expect(page).to have_content "Data de Entrada: #{I18n.localize(1.days.from_now.at_midday, format: :no_timezone)}"
      expect(page).to have_content "Data de Saída: #{I18n.localize(14.days.from_now.at_midday, format: :no_timezone)}"
      expect(page).to have_content "Horário de check-in e check-out: 12:00"
      expect(page).to have_content "Formas de pagamento aceitas:"
      expect(page).to have_content "Dinheiro"
      expect(page).to have_content "Valor total das diárias: R$13000"
      expect(page).to_not have_button "Cancelar Reserva"
      expect(page).to_not have_button "Realizar Check-in"
    end

    it 'vê reserva que está pendente com data de check-in em uma semana' do
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
      reservation = room.reservations.create!(user: guest, check_in: 7.days.from_now.at_midday, check_out: 14.days.from_now.at_midday, 
                            total_price: 7000, guests: 2, status: 'pending') 
      # Act
      login_as guest
      visit reservation_path(reservation)
      # Assert
      expect(page).to have_content "Reserva #{reservation.code}" 
      expect(page).to have_content "Status da Reserva: Pendente"
      expect(page).to have_content "Informações de reserva para o quarto: Quarto Master"
      expect(page).to have_content "Data de Entrada: #{I18n.localize(7.days.from_now.at_midday, format: :no_timezone)}"
      expect(page).to have_content "Data de Saída: #{I18n.localize(14.days.from_now.at_midday, format: :no_timezone)}"
      expect(page).to have_content "Horário de check-in e check-out: 12:00"
      expect(page).to have_content "Formas de pagamento aceitas:"
      expect(page).to have_content "Dinheiro"
      expect(page).to have_content "Valor total das diárias: R$7000"
      expect(page).to have_button "Cancelar Reserva"
    end

    it 'e reserva está ativa' do
      # Arrange
      guest = User.create!(email: 'guest@gmail.com', password: 'password', name: 'Guest',
                           registration_number: '99999999999')
      admin = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                          registration_number: '99999999999', admin: true)
      inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: admin, status: 'published')
      room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                               price: 1000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
      reservation = room.reservations.create!(user: guest, check_in: 1.day.from_now.at_midday, check_out: 14.days.from_now.at_midday, 
                                              total_price: 13000, guests: 2, status: 'active') 
      # Act
      login_as guest
      visit reservation_path(reservation)
      # Assert
      expect(page).to have_content "Reserva #{reservation.code}" 
      expect(page).to have_content "Status da Reserva: Ativa"
      expect(page).to have_content "Quarto Reservado: Quarto Master"
      expect(page).to have_content "Data de Entrada: #{I18n.localize(1.days.from_now.at_midday.in_time_zone('America/Sao_Paulo'), format: :no_timezone)}"
      expect(page).to have_content "Data de Saída: #{I18n.localize(14.days.from_now.at_midday, format: :no_timezone)}"
      expect(page).to_not have_link "Realizar Check-Out"
    end
  end
end