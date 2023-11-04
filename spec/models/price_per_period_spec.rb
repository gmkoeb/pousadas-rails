require 'rails_helper'

RSpec.describe PricePerPeriod, type: :model do
  describe '#valid?' do
    it 'usuário cria preço especial com datas sobrepostas' do
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
      price_1 = room.price_per_periods.create!(special_price: 1234, starts_at: 'Mon, 13 Nov 2023', ends_at: 'Mon, 20 Nov 2023')
      price_2 = room.price_per_periods.build(special_price: 12345, starts_at: 'Mon, 15 Nov 2023', ends_at: 'Mon, 20 Nov 2023')
      # Act
      result = price_2.valid?
      # Assert
      expect(result).to eq false
    end
  end
end
