class InnsController < ApplicationController
  def new
    @inn = Inn.new
    @payment_methods = ["Dinheiro", "PIX", "Cartão de crédito", "Cartão de débito"]
  end

  def create
    pp params
  end
end