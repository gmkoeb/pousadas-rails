require 'rails_helper'

describe 'Usuário checa se quarto está disponível para reservas' do
  it 'a partir da home' do
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
    # Assert
    expect(current_path).to eq new_room_reservation_path(room)
    expect(page).to have_field 'Quantidade de Hóspedes'
    expect(page).to have_field 'Data de Entrada'
    expect(page).to have_field 'Data de Saída'
  end

  it 'e quarto não suporta o número de hóspedes' do
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
                             price: 5000, maximum_guests: 4, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    # Act
    visit new_room_reservation_path(room)
    fill_in 'Quantidade de Hóspedes', with: '5'
    fill_in 'Data de Entrada', with: 1.day.from_now
    fill_in 'Data de Saída', with: 8.days.from_now
    click_on 'Verificar Disponibilidade'
    # Assert
    expect(page).to have_content 'Verifique os erros abaixo:' 
    expect(page).to have_content 'Quantidade de Hóspedes acima do suportado pelo quarto' 
  end

  it 'e quarto está disponível' do
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
                             price: 5000, maximum_guests: 4, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    # Act
    visit new_room_reservation_path(room)
    fill_in 'Quantidade de Hóspedes', with: '2'
    fill_in 'Data de Entrada', with: 1.day.from_now
    fill_in 'Data de Saída', with: 8.days.from_now
    click_on 'Verificar Disponibilidade'
    # Assert
    expect(page).to have_content 'Informações de reserva para o quarto: Quarto Master' 
    expect(page).to have_content "Data de Entrada: #{I18n.localize(1.day.from_now.at_midday, format: :no_timezone)}" 
    expect(page).to have_content "Data de Saída: #{I18n.localize(8.days.from_now.at_midday, format: :no_timezone)}" 
    expect(page).to have_content "Horário de check-in e check-out: 12:00" 
    expect(page).to have_content "Formas de pagamento aceitas:" 
    expect(page).to have_content "Dinheiro" 
    expect(page).to have_content 'Valor total das diárias: R$35000' 
    expect(page).to have_button 'Efetuar Reserva' 
  end

  it 'com data de check-in muito próxima' do
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
                             price: 5000, maximum_guests: 4, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    # Act
    visit new_room_reservation_path(room)
    fill_in 'Quantidade de Hóspedes', with: '2'
    fill_in 'Data de Entrada', with: 1.day.from_now
    fill_in 'Data de Saída', with: 7.days.from_now
    click_on 'Verificar Disponibilidade'
    # Assert
    expect(page).to have_content 'Você não poderá cancelar essa reserva' 
    expect(page).not_to have_content 'Você poderá cancelar a reserva em até 7 dias úteis antes da data de check-in' 
  end

  it 'com data de check-in com uma semana de antecedência' do
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
                             price: 5000, maximum_guests: 4, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    # Act
    visit new_room_reservation_path(room)
    fill_in 'Quantidade de Hóspedes', with: '2'
    fill_in 'Data de Entrada', with: 8.days.from_now
    fill_in 'Data de Saída', with: 15.days.from_now
    click_on 'Verificar Disponibilidade'
    # Assert
    expect(page).to have_content 'Você poderá cancelar a reserva em até 7 dias úteis antes da data de check-in' 
    expect(page).not_to have_content 'Você não poderá cancelar essa reserva' 
  end

  it 'e quarto têm preços especiais ativos' do
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
                             price: 1000, maximum_guests: 4, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    special_price = room.price_per_periods.create!(special_price: 10000, starts_at: 5.days.ago, ends_at: 5.days.from_now)                         
    # Act
    visit new_room_reservation_path(room)
    fill_in 'Quantidade de Hóspedes', with: '2'
    fill_in 'Data de Entrada', with: 1.day.from_now
    fill_in 'Data de Saída', with: 3.days.from_now
    click_on 'Verificar Disponibilidade'
    # Assert
    expect(page).to have_content 'Preço padrão da diária: R$ 1000'
    expect(page).to have_content 'Preço Especial: R$ 10000'
    expect(page).to have_content "Ativo até: #{I18n.localize(special_price.ends_at)}"  
    expect(page).to have_content 'Informações de reserva para o quarto: Quarto Master' 
    expect(page).to have_content "Data de Entrada: #{I18n.localize(1.day.from_now.at_midday, format: :no_timezone)}" 
    expect(page).to have_content "Data de Saída: #{I18n.localize(3.days.from_now.at_midday, format: :no_timezone)}" 
    expect(page).to have_content "Horário de check-in e check-out: 12:00" 
    expect(page).to have_content "Formas de pagamento aceitas:" 
    expect(page).to have_content "Dinheiro" 
    expect(page).to have_content 'Valor total das diárias: R$20000'
    expect(page).to have_button 'Efetuar Reserva' 
  end

end