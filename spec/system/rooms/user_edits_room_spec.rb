require 'rails_helper'

describe 'usuário edita quarto' do
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
    click_on 'Quartos'
    click_on 'Quarto Master'
    click_on 'Editar Quarto'
    # Assert
    expect(page).to have_content 'Editar Quarto'
    expect(page).to have_field 'Nome do quarto', with: 'Quarto Master'
    expect(page).to have_field 'Descrição', with: 'Melhor quarto da pousada.'
    expect(page).to have_field 'Área', with: 50
    expect(page).to have_field 'Número máximo de hóspedes', with: 5
    expect(page).to have_field 'Preço', with: 5000
    expect(page).to have_field 'Têm banheiro?'
    expect(page).to have_field 'Têm varanda?'
    expect(page).to have_field 'Têm ar condicionado?'
    expect(page).to have_field 'Têm TV?'
    expect(page).to have_field 'Têm armário?'
    expect(page).to have_field 'Têm cofre?'
    expect(page).to have_field 'É acessível para pessoas com deficiência?'
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
    inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                      price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
    # Act
    visit root_path
    within 'nav' do 
      click_on 'Minha pousada'
    end
    click_on 'Quartos'
    click_on 'Quarto Master'
    click_on 'Editar Quarto'

    fill_in 'Nome do quarto', with: 'Quarto Master Ultra'
    fill_in 'Descrição', with: 'Melhor que o melhor quarto da pousada.'
    fill_in 'Área', with: 500
    fill_in 'Número máximo de hóspedes', with: 50
    fill_in 'Preço', with: 200000
    check 'Têm banheiro?'
    check 'Têm varanda?'
    check 'Têm ar condicionado?'
    check 'Têm TV?'
    check 'Têm armário?'
    check 'Têm cofre?'
    check 'É acessível para pessoas com deficiência?'
    click_on 'Atualizar Quarto'
    # Assert
    expect(page).to have_content 'Quarto atualizado com sucesso!'
    expect(page).to have_content 'Quarto Master Ultra'
    expect(page).to have_content 'Descrição: Melhor que o melhor quarto da pousada.'
    expect(page).to have_content 'Área: 500 m²'
    expect(page).to have_content 'Preço padrão da diária: R$ 200000'
    expect(page).to have_content 'Número máximo de hóspedes: 50'
    expect(page).to have_content 'Possui banheiro próprio'
    expect(page).to have_content 'Possui ar condicionado'
    expect(page).to have_content 'Possui TV'
    expect(page).to have_content 'Possui armário'
    expect(page).to have_content 'Possui cofre'
    expect(page).to have_content 'É acessível para pessoas com deficiência'
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
    inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                      price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
    # Act
    visit root_path
    within 'nav' do 
      click_on 'Minha pousada'
    end
    click_on 'Quartos'
    click_on 'Quarto Master'
    click_on 'Editar Quarto'

    fill_in 'Nome do quarto', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Área', with: ''
    fill_in 'Número máximo de hóspedes', with: ''
    fill_in 'Preço', with: ''
    click_on 'Atualizar Quarto'
    # Assert
    expect(page).to have_content 'Não foi possível atualizar o quarto.'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Nome do quarto não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Área não pode ficar em branco'
    expect(page).to have_content 'Número máximo de hóspedes não pode ficar em branco'
    expect(page).to have_content 'Preço padrão não pode ficar em branco'
  end

  it 'em uma pousada que não é dele' do
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    user_2 = User.create!(email: 'admin@gmail.com', password: 'password', admin: 'true')
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                      price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
    inn_2 = Inn.create!(corporate_name: 'Pousadas Curitiba LTDA', brand_name: 'Pousada da Chuva', 
                        registration_number: '1233', phone: '4136223040', email: 'pousadachuva@gmail.com', 
                        address: 'Rua da pousada, 153', district: 'Santa Cândida', state: 'Paraná',
                        city: 'Curitiba', zip_code: '8230460', description: 'A melhor pousada de Curitiba',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user_2)
    login_as(user_2)
    # Act
    visit edit_inn_room_path(inn, room)
    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não pode realizar essa ação'
  end
end