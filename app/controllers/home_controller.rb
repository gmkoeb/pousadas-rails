class HomeController < ApplicationController
  def index
    admin_has_inn?
    @inns = Inn.published
  end
end