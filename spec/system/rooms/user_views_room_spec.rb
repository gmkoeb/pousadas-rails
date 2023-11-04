require 'rails_helper'

describe 'Usuário vê detalhes de um quarto' do
  it 'e vê informações adicionais' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user, status: 'published')
    inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                      price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'published')
    # Act
    visit root_path
    click_on 'Pousada do Luar'
    click_on 'Quarto'
    click_on 'Quarto Master'
    # Assert
    expect(page).to have_content 'Quarto Master'
    expect(page).to have_content 'Descrição: Melhor quarto da pousada.'
    expect(page).to have_content 'Área: 50 m²'
    expect(page).to have_content 'Preço padrão da diária: R$ 5000'
    expect(page).to have_content 'Número máximo de hóspedes: 5'
    expect(page).to have_content 'Possui banheiro próprio'
    expect(page).to have_content 'Não possui ar condicionado'
    expect(page).to have_content 'Não possui TV'
    expect(page).to have_content 'Não possui armário'
    expect(page).to have_content 'Não possui cofre'
    expect(page).to have_content 'É acessível para pessoas com deficiência'
    expect(page).to_not have_content 'Editar Quarto'
    expect(page).to_not have_content 'Esconder Quarto'
  end

  it 'e quarto não está disponível' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user, status: 'published')
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'draft')
    # Act
    visit inn_room_path(inn, room)
    # Assert
    expect(current_path).to eq inn_rooms_path(inn)
    expect(page).to have_content 'Este quarto não está aceitando reservas no momento.'
  end

  it 'e é dono da pousada' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user, status: 'published')
    inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                      price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true, status: 'draft')
    login_as(user)
    # Act
    visit root_path
    click_on 'Pousada do Luar'
    click_on 'Quarto'
    click_on 'Quarto Master'

    # Assert
    expect(page).to have_content 'Editar Quarto'
    expect(page).to have_content 'Publicar Quarto'
    expect(page).to have_content 'Definir Preços Por Período'
  end
end