class RegistrationsController < Devise::RegistrationsController
  protected
  def after_sign_up_path_for(resource)
    if current_user.admin?
      new_inn_path
    else
      super
    end 
  end
end
