class HomeController < ApplicationController
  def index
    admin_has_inn?
  end

  def admin_has_inn?
    return if current_user.nil?
      if current_user.admin?
        redirect_to new_inn_path, notice: 'Você não possui nenhuma pousada. Crie uma para continuar navegando' unless has_inn?(current_user)
      end
  end

  def has_inn?(user)
    inn = Inn.where(user:)
    inn.exists?
  end
end