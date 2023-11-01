class HomeController < ApplicationController
  def index
    admin_has_inn?
  end
end