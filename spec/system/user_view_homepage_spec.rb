require 'rails_helper'

describe 'Usuário não autenticado visita página inicial' do
  it 'e vê a logo da aplicação' do
    # Arrange

    # Act
    visit root_path
    # Assert
    expect(page).to have_content 'Pousadas Rails'
    expect(page).to_not have_content 'Home'
  end

  it 'e vê o botão de entrar' do
    # Arrange

    # Act
    visit root_path
    # Assert
    within 'nav' do
      expect(page).to have_content 'Entrar'
    end
    expect(page).to_not have_content 'Home'
  end
end