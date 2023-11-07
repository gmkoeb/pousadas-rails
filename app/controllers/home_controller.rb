class HomeController < ApplicationController
  def index
    admin_has_inn?
    @recent_inns = Inn.published.order(created_at: :desc).limit(3)
    @inns = Inn.published.excluding!(@recent_inns)
  end
end