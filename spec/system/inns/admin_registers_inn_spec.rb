require 'rails_helper'

describe 'Dono de pousadas cria uma pousada' do
  it 'from homepage' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    login_as(user)
    # Act
    visit root_path
    within 'nav' do
      click_on 'Cadastrar pousada'
    end
    # Assert
    expect(page).to have_content 'Cadastre sua Pousada'
    expect(page).to have_field 'Razão social'
    expect(page).to have_field 'Nome fantasia'
    expect(page).to have_field 'CNPJ'
    expect(page).to have_field 'Telefone para contato'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Endereço'
    expect(page).to have_field 'Bairro'
    expect(page).to have_field 'Estado'
    expect(page).to have_field 'Cidade'
    expect(page).to have_field 'CEP'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Formas de pagamento'
    expect(page).to have_field 'Permite pets'
    expect(page).to have_field 'Políticas de uso'
    expect(page).to have_content 'Horário padrão para check-in e check-out'
  end
end