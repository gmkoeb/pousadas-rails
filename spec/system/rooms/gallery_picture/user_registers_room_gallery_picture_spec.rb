require 'rails_helper'

describe 'Usuário cadastra imagem na galeria do quarto' do
  it 'a partir da home' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)
    # Act
    login_as(user)
    visit root_path
    click_on 'Minha pousada'
    click_on 'Quarto Master'
    click_on 'Adicionar Foto do Quarto'
    # Assert
    expect(current_path).to eq new_room_gallery_picture_path(room)
    expect(page).to have_field 'gallery_picture[picture]'
    expect(page).to have_button 'Adicionar Foto'
  end

  it 'com sucesso' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)

    image_path = Rails.root.join('spec', 'support', 'assets', 'test_img.jpg') 
    # Act
    login_as(user)
    visit new_room_gallery_picture_path(room)
    attach_file('gallery_picture[picture]', image_path)
    click_on 'Adicionar Foto'
    # Assert
    expect(current_path).to eq room_path(room)
    expect(page).to have_content 'Imagem adicionada com sucesso'
    expect(page).to have_css 'img'
  end

  it 'com formato errado' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                        registration_number: '99999999999', admin: true)
    inn = Inn.create!(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                      registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                      address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                      city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                      payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                      check_in_check_out_time: '12:00', user: user)
    room = inn.rooms.create!(name: 'Quarto Master', description: 'Melhor quarto da pousada.', area: 50, 
                             price: 5000, maximum_guests: 5, has_bathroom: true, has_balcony: true, accessible: true)

    image_path = Rails.root.join('spec', 'support', 'assets', 'img_pdf.pdf') 
    # Act
    login_as(user)
    visit new_room_gallery_picture_path(room)
    attach_file('gallery_picture[picture]', image_path)
    click_on 'Adicionar Foto'
    # Assert
    expect(page).to have_content 'Não foi possível adicionar imagem'
    expect(page).to have_content 'Imagem deve possuir extensão JPEG ou PNG'
  end
end