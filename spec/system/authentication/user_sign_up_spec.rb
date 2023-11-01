require 'rails_helper'
describe 'Usuario cria uma conta' do
  it 'com sucesso' do
    # Arrange 

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'email@email.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: '123456'
    click_on 'Criar conta'

    # Assert
    expect(page).to have_content 'Boas vindas! Você realizou seu cadastro com sucesso.'
    expect(page).to have_content 'email@email.com'
    expect(page).to have_button 'Sair'
  end

  it 'como dono de pousadas' do
    # Arrange 

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'email@email.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: '123456'
    check 'Dono de pousadas'
    click_on 'Criar conta'

    # Assert
    expect(current_path).to eq new_inn_path
    expect(page).to have_content 'Boas vindas! Você realizou seu cadastro com sucesso.'
    expect(page).to have_content 'Cadastrar pousada'
    expect(page).to have_content 'email@email.com'
    expect(page).to have_button 'Sair'
  end

  it 'como usuário padrão' do
    # Arrange 

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'email@email.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: '123456'
    click_on 'Criar conta'

    # Assert
    expect(page).to have_content 'Boas vindas! Você realizou seu cadastro com sucesso.'
    expect(page).to_not have_content 'Cadastrar pousada'
    expect(page).to have_content 'email@email.com'
    expect(page).to have_button 'Sair'
  end

  it 'com dados faltando' do
    # Arrange 

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'email@email.com'
    fill_in 'Senha', with: ''
    fill_in 'Confirme sua senha', with: ''
    click_on 'Criar conta'

    # Assert
    expect(page).to have_content 'Não foi possível salvar usuário: 1 erro'
    expect(page).to have_content 'Senha não pode ficar em branco'
  end

  it 'com senha de confirmação diferente da senha' do
    # Arrange 

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'email@email.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    # Assert
    expect(page).to have_content 'Não foi possível salvar usuário: 1 erro'
    expect(page).to have_content 'Confirme sua senha não é igual a Senha'
  end

  it 'com e-mail já existente' do
    # Arrange 
    User.create!(email: 'email@email.com', password: '123456')
    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'email@email.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: '123456'
    click_on 'Criar conta'
    # Assert
    expect(page).to have_content 'Não foi possível salvar usuário: 1 erro'
    expect(page).to have_content 'E-mail já está em uso'
  end
end