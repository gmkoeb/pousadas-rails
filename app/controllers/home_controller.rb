class HomeController < ApplicationController
  before_action :admin_has_inn?
  def index
    @inns = Inn.published
    @recent_inns = Inn.published.order(created_at: :desc).limit(3)
    @cities = @inns.map(&:city).uniq
  end
end