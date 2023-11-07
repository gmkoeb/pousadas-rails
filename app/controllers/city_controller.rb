class CityController < ApplicationController
  def index
    @city = params[:city]
    @inns = Inn.where(city: @city).published.sort_by { |inn| inn[:brand_name] }
  end
end