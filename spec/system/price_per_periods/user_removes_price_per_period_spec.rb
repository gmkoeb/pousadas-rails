require 'rails_helper'
describe 'usuário remove preço por período' do
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
    room.price_per_periods.create!(special_price: 1234, starts_at: Date.today, ends_at: Date.tomorrow)     
    # Act
    visit root_path
    click_on 'Minha pousada'
    click_on 'Quarto Master'
    within 'table' do
      click_on 'Remover'
    end
    # Assert
    expect(page).to_not have_content 'R$ 1234'
    expect(page).to_not have_content I18n.localize(Date.today)
    expect(page).to_not have_content I18n.localize(Date.tomorrow)
  end
end