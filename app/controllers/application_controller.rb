class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:admin])
  end

  private
  def admin_has_inn?
    return if current_user.nil?
      if current_user.admin?
        redirect_to new_inn_path, notice: 'Você não possui nenhuma pousada. Crie uma para continuar navegando' unless current_user.inn
      end
  end
end
