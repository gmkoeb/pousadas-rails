require 'rails_helper'

describe 'Usuário reserva um quarto' do
  it 'e não está autenticado' do
    # Arrange
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
    # Act
    visit root_path
    click_on 'Pousada do Luar', :match => :first
    click_on 'Quarto Master'
    click_on 'Reservar Quarto'
    fill_in 'Quantidade de Hóspedes', with: '5'
    fill_in 'Data de Entrada', with: Time.current
    fill_in 'Data de Saída', with: 7.days.from_now
    click_on 'Verificar Disponibilidade'
    click_on 'Efetuar Reserva'
    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'após se autenticar' do
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
                             price: 5000, maximum_guests: 4, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('123ABCDE')                         
    # Act
    visit new_room_reservation_path(room)
    fill_in 'Quantidade de Hóspedes', with: '2'
    fill_in 'Data de Entrada', with: Time.current
    fill_in 'Data de Saída', with: 7.days.from_now
    click_on 'Verificar Disponibilidade'
    login_as(guest)
    click_on 'Efetuar Reserva'
    # Assert
    expect(current_path).to eq reservation_path(Reservation.last)
    expect(page).to have_content 'Reserva 123ABCDE'
    expect(page).to have_content 'Informações de reserva para o quarto: Quarto Master'
    expect(page).to have_content "Data de Entrada: #{I18n.localize(Time.now.utc.at_midday, format: :no_timezone)}"
    expect(page).to have_content "Data de Saída: #{I18n.localize(Time.now.utc.at_midday + 7.days, format: :no_timezone)}"
    expect(page).to have_content 'Horário de check-in e check-out: 12:00'
    expect(page).to have_content "Formas de pagamento aceitas:"
    expect(page).to have_content "Dinheiro"
    expect(page).to have_content "Valor total das diárias: R$35000"
  end

  it 'e já está autenticado' do
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
                             price: 5000, maximum_guests: 4, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('123ABCDE')                         
    # Act
    login_as(guest)
    visit new_room_reservation_path(room)
    fill_in 'Quantidade de Hóspedes', with: '2'
    fill_in 'Data de Entrada', with: Time.current
    fill_in 'Data de Saída', with: 7.days.from_now
    click_on 'Verificar Disponibilidade'
    click_on 'Efetuar Reserva'
    # Assert
    expect(current_path).to eq reservation_path(Reservation.last)
    expect(page).to have_content 'Reserva 123ABCDE'
    expect(page).to have_content 'Informações de reserva para o quarto: Quarto Master'
    expect(page).to have_content "Data de Entrada: #{I18n.localize(DateTime.now.utc.at_midday, format: :no_timezone)}"
    expect(page).to have_content "Data de Saída: #{I18n.localize(7.days.from_now.at_midday, format: :no_timezone)}"
    expect(page).to have_content 'Horário de check-in e check-out: 12:00'
    expect(page).to have_content "Formas de pagamento aceitas:"
    expect(page).to have_content "Dinheiro"
    expect(page).to have_content "Valor total das diárias: R$35000"
  end
end