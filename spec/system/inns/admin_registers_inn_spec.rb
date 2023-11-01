require 'rails_helper'

describe 'Dono de pousadas cria uma pousada' do
  it 'a partir da home' do
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
    expect(page).to have_unchecked_field 'inn_payment_methods_cartão_de_débito'
    expect(page).to have_unchecked_field 'inn_payment_methods_cartão_de_crédito'
    expect(page).to have_unchecked_field 'inn_payment_methods_pix'
    expect(page).to have_unchecked_field 'inn_payment_methods_dinheiro'
    expect(page).to have_content 'Formas de pagamento'
    expect(page).to have_field 'Permite pets'
    expect(page).to have_field 'Políticas de uso'
    expect(page).to have_content 'Horário padrão para check-in e check-out'
  end

  it 'com sucesso' do
    # Arrange
    user = User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    login_as(user)

    # Act
    visit root_path
    click_on 'Cadastrar pousada'
    fill_in 'Razão social', with: 'Pousadas Florianópolis LTDA'
    fill_in 'Nome fantasia', with: 'Pousada do Luar'
    fill_in 'CNPJ', with: '34133123'    
    fill_in 'Telefone para contato', with: '45995320332'
    fill_in 'E-mail', with: 'pousadadoluar@gmail.com'
    fill_in 'Endereço', with: 'Rua da pousada, 114'
    fill_in 'Bairro', with: 'Beira Mar Norte'
    fill_in 'Estado', with: 'Santa Catarina'
    fill_in 'Cidade', with: 'Florianópolis'
    fill_in 'CEP', with: '42830460'
    fill_in 'Descrição', with: 'A melhor pousada de Florianópolis'
    check 'inn_payment_methods_cartão_de_débito'
    check 'inn_payment_methods_cartão_de_crédito'
    check 'inn_payment_methods_pix'
    check 'inn_payment_methods_dinheiro'
    check 'Permite pets'
    fill_in 'Políticas de uso', with: 'Não pode som alto após as 18h'
    select '12', from: 'inn[check_in_check_out_time(4i)]'
    select '00', from: 'inn[check_in_check_out_time(5i)]'
    click_on 'Criar pousada'
    # Assert
    expect(current_path).to eq inn_path('pousada-do-luar')
    expect(page).to have_content 'Pousada cadastrada com sucesso! 😊'
    expect(page).to have_content 'Razão social: Pousadas Florianópolis LTDA'
    expect(page).to have_content 'Nome fantasia: Pousada do Luar'
    expect(page).to have_content 'CNPJ: 34133123'
    expect(page).to have_content 'Telefone para contato: 45995320332'
    expect(page).to have_content 'E-mail: pousadadoluar@gmail.com'
    expect(page).to have_content 'Endereço completo: Rua da pousada, 114. Beira Mar Norte, Florianópolis - Santa Catarina.'
    expect(page).to have_content 'CEP: 42830460'
    expect(page).to have_content 'Descrição: A melhor pousada de Florianópolis'
    expect(page).to have_content 'Formas de pagamento'
    expect(page).to have_content 'Cartão de débito'
    expect(page).to have_content 'Cartão de crédito'
    expect(page).to have_content 'PIX'
    expect(page).to have_content 'Dinheiro'
    expect(page).to have_content 'Permite pets: Sim'
    expect(page).to have_content 'Políticas de uso: Não pode som alto após as 18h'
    expect(page).to have_content 'Horário padrão de check-in e check-out: 12:00'
  end
end