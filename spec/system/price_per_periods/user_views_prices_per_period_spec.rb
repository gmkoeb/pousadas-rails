require 'rails_helper'
describe 'usuário vê preços por período' do
  it 'e não vê se não é dono da pousada' do
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
    room.price_per_periods.create!(special_price: 1234, starts_at: Date.today, ends_at: Date.tomorrow)     
    # Act
    visit root_path
    click_on 'Pousada do Luar', :match => :first
    click_on 'Quarto Master'
    # Assert
    expect(page).to_not have_content 'Preços Por Período'
    expect(page).to_not have_content 'R$ 1234'
    expect(page).to_not have_content I18n.localize(Date.today)
    expect(page).to_not have_content I18n.localize(Date.tomorrow)
  end

  it 'e vê todos os preços por período se é dono da pousada' do
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
    room.price_per_periods.create!(special_price: 1234, starts_at: Date.today, ends_at: Date.tomorrow)     
    # Act
    login_as(user)
    visit root_path
    click_on 'Pousada do Luar', :match => :first
    click_on 'Quarto Master'
    # Assert
    expect(page).to have_content 'Preços Por Período'
    expect(page).to have_content 'R$ 1234'
    expect(page).to have_content I18n.localize(Date.today)
    expect(page).to have_content I18n.localize(Date.tomorrow)
  end
end