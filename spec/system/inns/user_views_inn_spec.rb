require 'rails_helper'

describe 'usuário vê detalhes de uma pousada' do
  it 'a partir da home' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user, status: "published" )
    # Act
    visit root_path
    click_on 'Pousada do Luar'
    # Assert
    expect(page).to have_content 'Pousada do Luar'
    expect(page).to have_content 'Detalhes da pousada'
    expect(page).to have_content 'Formas de pagamento:'
    expect(page).to have_content 'Dinheiro'
    expect(page).to have_content 'Essa pousada não permite pets. 😣'
    expect(page).to have_content 'Endereço completo: Rua das pousadas, 114. Beira Mar Norte, Florianópolis - Santa Catarina.'
    expect(page).to have_content 'Horário padrão de check-in e check-out: 12:00'
    expect(page).to have_content 'Políticas de uso: Proibido som alto após as 18h'
    expect(page).to have_content 'Descrição: A melhor pousada de Florianópolis'
    expect(page).to_not have_link 'Editar'
    expect(page).to_not have_button 'Esconder pousada'
  end

  it 'que não está disponível' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user, status: "draft" )
    # Act
    visit inn_path('pousada-do-luar')
    # Assert
    expect(page).to have_content 'Esta pousada não está aceitando reservas' 
  end
end

describe 'Dono de pousadas vê detalhes da sua pousada' do
  it 'a partir da home' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    login_as(user)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user, status: "draft")
  # Act
  visit root_path
  within 'nav' do
    click_on 'Minha pousada'
  end
  # Assert
  expect(page).to have_content 'Razão social: Pousadas Florianópolis LTDA'
  expect(page).to have_content 'Nome fantasia: Pousada do Luar'
  expect(page).to have_content 'CNPJ: 4333123'
  expect(page).to have_content 'Telefone para contato: 41995203040'
  expect(page).to have_content 'E-mail: pousadadoluar@gmail.com'
  expect(page).to have_content 'Endereço completo: Rua das pousadas, 114. Beira Mar Norte, Florianópolis - Santa Catarina.'
  expect(page).to have_content 'CEP: 42830460'
  expect(page).to have_content 'Descrição: A melhor pousada de Florianópolis'
  expect(page).to have_content 'Formas de pagamento'
  expect(page).to have_content 'Dinheiro'
  expect(page).to have_content 'Permite pets: Não'
  expect(page).to have_content 'Políticas de uso: Proibido som alto após as 18h'
  expect(page).to have_content 'Horário padrão de check-in e check-out: 12:00'
  expect(page).to have_content 'ATENÇÃO: Ao publicar a pousada ela poderá ser visualizada por outros usuários.'
  expect(page).to have_link 'Editar'
  expect(page).to have_button 'Publicar pousada'
  end

  it 'e a publica' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    login_as(user)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua das pousadas, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Proibido som alto após as 18h',
                      check_in_check_out_time: '12:00', user: user, status: "draft")
  # Act
  visit root_path
  within 'nav' do
    click_on 'Minha pousada'
  end
  click_on 'Publicar pousada'
  within 'nav' do
    click_on 'Home'
  end
  # Assert
  expect(page).to have_content 'Pousada do Luar'
  expect(page).to have_content 'Endereço: Rua das pousadas, 114. Beira Mar Norte, Florianópolis - Santa Catarina'
  expect(page).to have_content 'Telefone para contato: 41995203040'
  expect(page).to have_content 'E-mail: pousadadoluar@gmail.com'
  end
end