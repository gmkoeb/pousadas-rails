class HomeController < ApplicationController
  def index
    admin_has_inn?
    @inns = Inn.published
    @recent_inns = Inn.published.order(created_at: :desc).limit(3)
  end
end