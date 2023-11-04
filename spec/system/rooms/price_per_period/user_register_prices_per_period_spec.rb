require 'rails_helper'

describe 'usuário cadastra preços especiais' do
  it 'a partir da home' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    login_as(user)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
    inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                      price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
    # Act
    visit root_path
    within 'nav' do
      click_on 'Minha pousada'
    end
    click_on 'Quarto'
    click_on 'Quarto Master'
    click_on 'Definir Preços Por Período'
    # Assert
    expect(page).to have_content 'Registrar Preço Por Período'
    expect(page).to have_field 'Preço Especial'
    expect(page).to have_field 'Data de Ínicio'
    expect(page).to have_field 'Data de Término'
  end

  it 'com sucesso' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    login_as(user)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
    # Act
    visit root_path
    within 'nav' do
      click_on 'Minha pousada'
    end
    click_on 'Quarto'
    click_on 'Quarto Master'
    click_on 'Definir Preços Por Período'

    # Act
    fill_in 'Preço Especial', with: '10000'
    fill_in 'Data de Ínicio', with: '01/12/2023'
    fill_in 'Data de Término', with: '01/01/2024'
    click_on 'Enviar'

    # Assert
    expect(current_path).to eq inn_room_path(inn, room)
    expect(page).to have_content 'Preço por período cadastrado com sucesso.'
    expect(page).to have_content 'Preços por Período'
    expect(page).to have_content 'Preço Especial'
    expect(page).to have_content 'Data de Ínicio'
    expect(page).to have_content 'Data de Término'
    expect(page).to have_content '10000'
    expect(page).to have_content '01/12/2023'
    expect(page).to have_content '01/01/2024'
  end

  it 'com dados faltando' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    login_as(user)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
    # Act
    visit root_path
    within 'nav' do
      click_on 'Minha pousada'
    end
    click_on 'Quarto'
    click_on 'Quarto Master'
    click_on 'Definir Preços Por Período'
    # Act
    click_on 'Enviar'
    # Assert
    expect(page).to have_content 'Não foi possível cadastrar preço especial.'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Data de Ínicio não pode ficar em branco'
    expect(page).to have_content 'Data de Término não pode ficar em branco'
    expect(page).to have_content 'Preço Especial não pode ficar em branco'
  end

  it 'com datas sobrepostas' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    login_as(user)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)                  
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
    room.price_per_periods.create!(special_price: 1234, starts_at: 'Mon, 13 Nov 2023', ends_at: 'Mon, 20 Nov 2023')                         
    # Act
    visit root_path
    within 'nav' do
      click_on 'Minha pousada'
    end
    click_on 'Quarto'
    click_on 'Quarto Master'
    click_on 'Definir Preços Por Período'
    fill_in 'Preço Especial', with: '10000'
    fill_in 'Data de Ínicio', with: '01/01/2023'
    fill_in 'Data de Término', with: '19/11/2023'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Não foi possível cadastrar preço especial.'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Já existe um preço especial nessa data!'
  end

  it 'com datas inválidas' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    login_as(user)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)                  
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)                       
    # Act
    visit root_path
    within 'nav' do
      click_on 'Minha pousada'
    end
    click_on 'Quarto'
    click_on 'Quarto Master'
    click_on 'Definir Preços Por Período'
    fill_in 'Preço Especial', with: '10000'
    fill_in 'Data de Ínicio', with: '01/01/2023'
    fill_in 'Data de Término', with: '19/11/2022'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Não foi possível cadastrar preço especial.'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Data de ínicio precisa ser maior que a data de término'
  end
end