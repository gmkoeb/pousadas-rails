require 'rails_helper'

describe 'Dono de pousadas edita pousada' do
  it 'a partir da home' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    login_as(user)
    Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user)
    # Act 
    visit root_path
    within 'nav' do
      click_on 'Minha pousada'
    end
    click_on 'Editar'
    # Assert
    expect(page).to have_content 'Editar Pousada'
    expect(page).to have_field 'Razão social', with: 'Pousadas Florianópolis LTDA'
    expect(page).to have_field 'Nome fantasia', with: 'Pousada do Luar'
    expect(page).to have_field 'CNPJ', with: '4333123'
    expect(page).to have_field 'Telefone para contato', with: '41995203040'
    expect(page).to have_field 'E-mail', with: 'pousadadoluar@gmail.com'
    expect(page).to have_field 'Endereço', with: 'Rua da pousada, 114'
    expect(page).to have_field 'Bairro', with: 'Beira Mar Norte'
    expect(page).to have_field 'Estado', with: 'Santa Catarina'
    expect(page).to have_field 'Cidade', with: 'Florianópolis'
    expect(page).to have_field 'CEP', with: '42830460'
    expect(page).to have_field 'Descrição', with: 'A melhor pousada de Florianópolis'
    expect(page).to have_content 'Formas de pagamento'
    expect(page).to have_unchecked_field 'inn_payment_methods_cartão_de_débito'
    expect(page).to have_unchecked_field 'inn_payment_methods_cartão_de_crédito'
    expect(page).to have_unchecked_field 'inn_payment_methods_pix'
    expect(page).to have_unchecked_field 'inn_payment_methods_dinheiro'
    expect(page).to have_field 'Permite pets'
    expect(page).to have_field 'Políticas de uso', with: 'Não pode som alto após as 18h'
    expect(page).to have_content 'Horário padrão para check-in e check-out'
  end

  it 'com sucesso' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    login_as(user)
    Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Não pode som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user)
    # Act 
    visit root_path
    within 'nav' do
      click_on 'Minha pousada'
    end
    click_on 'Editar'
    fill_in 'Razão social', with: 'Pousadas Florianópolis Editadas LTDA'
    fill_in 'Nome fantasia', with: 'Pousada do Sol'
    fill_in 'E-mail', with: 'pousadadosol@gmail.com'
    check 'inn_payment_methods_cartão_de_débito'
    check 'inn_payment_methods_cartão_de_crédito'
    check 'inn_payment_methods_pix'
    check 'inn_payment_methods_dinheiro'
    check 'Permite pets'
    fill_in 'Políticas de uso', with: 'Não pode som alto após as 18h'
    select '12', from: 'inn[check_in_check_out_time(4i)]'
    select '00', from: 'inn[check_in_check_out_time(5i)]'
    click_on 'Atualizar Pousada'
    # Assert
    expect(page).to have_content 'Pousada atualizada com sucesso!'
    expect(page).to have_content 'Razão social: Pousadas Florianópolis Editadas LTDA'
    expect(page).to have_content 'Nome fantasia: Pousada do Sol'
    expect(page).to have_content 'E-mail: pousadadosol@gmail.com'
    expect(page).to have_content 'Formas de pagamento'
    expect(page).to have_content 'Cartão de débito'
    expect(page).to have_content 'Cartão de crédito'
    expect(page).to have_content 'PIX'
    expect(page).to have_content 'Dinheiro'
    expect(page).to have_content 'Permite pets: Sim'
  end

  it 'com dados faltando' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    login_as(user)
    Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Não pode som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user)
    # Act 
    visit root_path
    within 'nav' do
      click_on 'Minha pousada'
    end
    click_on 'Editar'
    fill_in 'Razão social', with: ''
    check 'Permite pets'
    fill_in 'Políticas de uso', with: 'Não pode som alto após as 18h'
    select '12', from: 'inn[check_in_check_out_time(4i)]'
    select '00', from: 'inn[check_in_check_out_time(5i)]'
    click_on 'Atualizar Pousada'
    # Assert
    expect(page).to have_content 'Não foi possível atualizar a pousada.'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Razão social não pode ficar em branco'
  end

  it 'que não é dele' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    user_2 = User.create!(email: 'admin@admin.com', password: 'password', admin: 'true')
    login_as(user_2)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Não pode som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user)
    inn_2 = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Sol', 
                  registration_number: '2333123', phone: '45995203040', email: 'pousadadosol@gmail.com', 
                  address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                  city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                  payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Não pode som alto após as 18h', 
                  check_in_check_out_time: '12:00', user: user_2)
    # Act
    visit edit_inn_path(inn.slug)
    # Assert
    expect(current_path).to eq(root_path)
    expect(page).to have_content 'Você só pode editar as suas pousadas.'
  end
end

describe 'Usuário comum tenta editar uma pousada' do
  it 'a partir da home' do
    # Arrange
    user = User.create!(email: 'gmkoeb1@gmail.com', password: 'password')
    user_2 = User.create!(email: 'admin@admin.com', password: 'password', admin: 'true')
    login_as(user)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user_2)
    # Act
    visit edit_inn_path(inn.slug)
    # Assert
    expect(current_path).to eq(root_path)
    expect(page).to have_content 'Você precisa ser um dono de pousadas para realizar essa operação.'
  end
end