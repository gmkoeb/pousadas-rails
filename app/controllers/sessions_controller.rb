class SessionsController < Devise::SessionsController
  protected
  def after_sign_in_path_for(resource)
    if current_user.admin?
      if current_user.inn.nil?
        new_inn_path
      else
        root_path
      end
    else
      root_path
    end 
  end
end