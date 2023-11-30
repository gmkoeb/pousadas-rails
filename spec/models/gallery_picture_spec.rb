require 'rails_helper'

RSpec.describe GalleryPicture, type: :model do

  describe '#valid?' do
    it 'formato de imagem correto' do
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                          registration_number: '99999999999', admin: true)
      inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user)
      image_path = Rails.root.join('spec', 'support', 'assets', 'test_img.jpg')
      picture = fixture_file_upload(image_path, 'image/jpeg') 

      picture = inn.gallery_pictures.build(picture: picture)
      # Act
      result = picture.valid?

      # Assert
      expect(result).to be true  
    end

    it 'formato de imagem incorreto' do
      # Arrange
      user = User.new(email: 'gmkoeb@gmail.com', password: 'password', name: 'Gabriel', 
                          registration_number: '99999999999', admin: true)
      inn = Inn.new(corporate_name: 'Pousadas Florianópolis LTDA', brand_name: 'Pousada do Luar', 
                        registration_number: '4333123', phone: '41995203040', email: 'pousadadoluar@gmail.com', 
                        address: 'Rua da pousada, 114', district: 'Beira Mar Norte', state: 'Santa Catarina',
                        city: 'Florianópolis', zip_code: '42830460', description: 'A melhor pousada de Florianópolis',
                        payment_methods: '["Dinheiro"]', accepts_pets: 'true', terms_of_service: 'Não pode som alto após as 18h', 
                        check_in_check_out_time: '12:00', user: user)
      image_path = Rails.root.join('spec', 'support', 'assets', 'img_pdf.pdf')
      picture = fixture_file_upload(image_path, 'image/pdf') 

      picture = inn.gallery_pictures.build(picture: picture)
      # Act
      picture.valid?
      result = picture.errors.include?(:picture)
      # Assert
      expect(result).to be true 
      expect(picture.errors[:picture]).to include 'deve possuir extensão JPEG ou PNG'
    end
  end
end
