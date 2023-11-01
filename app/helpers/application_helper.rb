module ApplicationHelper
  private
  def user_has_inn?(user)
    inn = Inn.where(user:)
    inn.exists?
  end

  def find_user_inn(user)
    Inn.where(user:).first.slug
  end
end
