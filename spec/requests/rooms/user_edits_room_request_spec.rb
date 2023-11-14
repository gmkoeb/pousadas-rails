require 'rails_helper'
describe 'Usuario edita o quarto de uma pousada' do
  it 'e não está logado' do
    # Arrange
    user = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                    registration_number: '99999999999')
    inn = Inn.create!(corporate_name: 'Pousada Repetida LTDA', brand_name: 'Pousada do Luar', 
      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
      payment_methods: 'Dinheiro', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
      check_in_check_out_time: '12:00', user: user)
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                      price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
    # Act
    patch(room_path(room), params:{ inn: {name: 'Quarto Editado'} })
    # Assert
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'e não é dono da pousada' do
    # Arrange
    user_1 = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                      registration_number: '99999999999')
    user_2 = User.new(email: 'admin@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                      registration_number: '99999999999')
    inn = Inn.create!(corporate_name: 'Pousada Repetida LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: 'Dinheiro', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user_1)
    inn_2 = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Sol', 
                        registration_number: '2333123', phone: '45995203040', email: 'pousadadosol@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'false', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user_2)  
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)                    
    # Act
    login_as(user_2)
    patch(room_path(room), params:{ room: {name: 'Quarto Editado'} })
    # Assert
    expect(response).to redirect_to(root_path)
  end

  it 'e não é dono de pousadas' do
    # Arrange
    user_1 = User.new(email: 'gmkoeb@gmail.com', password: 'password', admin: true, name: 'Gabriel', 
                      registration_number: '99999999999')
    user_2 = User.new(email: 'admin@gmail.com', password: 'password', admin: false, name: 'Gabriel', 
                      registration_number: '99999999999')
    inn = Inn.create!(corporate_name: 'Pousada Repetida LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: 'Dinheiro', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user_1)
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)                    
    # Act
    login_as(user_2)
    patch(room_path(room), params:{ room: {name: 'Quarto Editado'} })
    # Assert
    expect(response).to redirect_to(root_path)
  end
end