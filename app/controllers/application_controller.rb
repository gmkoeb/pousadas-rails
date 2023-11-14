class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:admin, :name, :registration_number])
  end

  private
  def authenticate_admin!
    authenticate_user!
    redirect_to root_path, notice: 'Você precisa ser um dono de pousadas para realizar essa operação.' unless current_user.admin?
  end

  def admin_has_inn?
    return if current_user.nil?
      if current_user.admin?
        redirect_to new_inn_path, alert: 'Você não possui nenhuma pousada. Crie uma para continuar navegando' if current_user.inn.nil?
      end
  end
end
