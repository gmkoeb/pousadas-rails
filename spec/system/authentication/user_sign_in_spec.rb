require 'rails_helper'

describe 'Usuário padrão se autentica' do
  it 'com sucesso' do
    # Arrange
    User.create!(email: 'gmkoeb@gmail.com', password: 'password')
    # Act
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'gmkoeb@gmail.com'
    fill_in 'Senha', with: 'password'
    within '.actions' do
      click_on 'Entrar'
    end
    # Assert
    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).not_to have_link 'Entrar'
    expect(page).not_to have_link 'Cadastrar pousada'
    expect(page).to have_button 'Sair'
    within 'nav' do
      expect(page).to have_content 'gmkoeb@gmail.com'
    end
  end

  it 'e realiza log out' do
    # Arrange
    User.create!(email: 'gmkoeb@gmail.com', password: 'password')
    # Act
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'gmkoeb@gmail.com'
    fill_in 'Senha', with: 'password'
    within '.actions' do
      click_on 'Entrar'
    end
    click_on 'Sair'
    # Assert
    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_content 'gmkoeb@gmail.com'
    expect(page).not_to have_button 'Sair'
  end

  it 'com informações incorretas' do
    # Arrange
    User.create!(email: 'gmkoeb@gmail.com', password: 'password')
    # Act
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'gmkoeb@gmail.com'
    fill_in 'Senha', with: 'password123'
    within '.actions' do
      click_on 'Entrar'
    end
    # Assert
    expect(page).to have_content 'E-mail ou senha inválidos.'
  end
end

describe 'Usuário admin se autentica' do
  it 'com sucesso' do
    # Arrange
    User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    # Act
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'gmkoeb@gmail.com'
    fill_in 'Senha', with: 'password'
    within '.actions' do
      click_on 'Entrar'
    end
    # Assert
    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).not_to have_link 'Entrar'
    expect(page).to have_link 'Cadastrar pousada'
    expect(page).to have_button 'Sair'
    within 'nav' do
      expect(page).to have_content 'gmkoeb@gmail.com'
    end
  end

  it 'e não possui pousadas cadastradas' do
    # Arrange
    User.create!(email: 'gmkoeb@gmail.com', password: 'password', admin: 'true')
    # Act
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'gmkoeb@gmail.com'
    fill_in 'Senha', with: 'password'
    within '.actions' do
      click_on 'Entrar'
    end
    # Assert
    expect(current_path).to eq new_inn_path
    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).not_to have_link 'Entrar'
    expect(page).to have_link 'Cadastrar pousada'
    expect(page).to have_button 'Sair'
    within 'nav' do
      expect(page).to have_content 'gmkoeb@gmail.com'
    end
  end
end