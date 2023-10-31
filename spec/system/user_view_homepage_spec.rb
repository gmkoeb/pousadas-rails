require 'rails_helper'

describe 'Usuário visita página inicial' do
  it 'e vê a logo da aplicação' do
    # Arrange

    # Act
    visit root_path
    # Assert
    expect(page).to have_content 'Pousadas Rails'
  end
end