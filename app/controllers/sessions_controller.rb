class SessionsController < Devise::SessionsController
  protected
  def after_sign_in_path_for(resource)
    if current_user.admin?
      new_inn_path
    else
      root_path
    end 
  end
end