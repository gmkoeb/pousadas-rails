require 'rails_helper'
describe 'Usuario edita uma pousada' do
  it 'e não está logado' do
    # Arrange
    user = User.create!(email: 'gabriel@gmail.com', password: 'password', admin:true)
    inn = Inn.create!(corporate_name: 'Pousada Repetida LTDA', brand_name: 'Pousada do Luar', 
      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
      payment_methods: 'Dinheiro', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
      check_in_check_out_time: '12:00', user: user)
    # Act
    patch(inn_path(inn), params:{ inn: {brand_name: 'Pousadas sem Dono'} })
    # Assert
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'e pousada não é dele' do
    # Arrange
    user = User.create!(email: 'gabriel@gmail.com', password: 'password', admin: true)
    user_2 = User.create!(email: 'admin@gmail.com', password: 'password', admin: true)
    inn = Inn.create!(corporate_name: 'Pousada Repetida LTDA', brand_name: 'Pousada do Luar', 
                registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                payment_methods: 'Dinheiro', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                check_in_check_out_time: '12:00', user: user)
    inn_2 = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Sol', 
                  registration_number: '2333123', phone: '45995203040', email: 'pousadadosol@gmail.com', 
                  address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                  city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                  payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Não pode som alto após as 18h', 
                  check_in_check_out_time: '12:00', user: user_2)            
    # Act
    login_as(user_2)
    patch(inn_path(inn), params:{ inn: {brand_name: 'Pousadas sem Dono'} })
    # Assert
    expect(response).to redirect_to(root_path)
  end

  it 'e não possui pousada' do
    # Arrange
    user = User.create!(email: 'gabriel@gmail.com', password: 'password', admin:true)
    user_2 = User.create!(email: 'admin@gmail.com', password: 'password', admin: true)
    inn = Inn.create!(corporate_name: 'Pousada Repetida LTDA', brand_name: 'Pousada do Luar', 
      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
      payment_methods: 'Dinheiro', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
      check_in_check_out_time: '12:00', user: user)
    login_as(user_2)
    # Act
    patch(inn_path(inn), params:{ inn: {brand_name: 'Pousadas sem Dono'} })
    # Assert
    expect(response).to redirect_to(new_inn_path)
  end
end