module InnsHelper
  private
  def accepted_payment(method)
    return false unless @inn
    return false if @inn.payment_methods.nil?

    @inn.payment_methods.include? method
  end

  def payment_methods
    ["Dinheiro", "PIX", "Cartão de crédito", "Cartão de débito"]
  end

  def accepts_pets?(accepts)
    if accepts
      'Essa pousada permite pets! 🐶'
    else
      'Essa pousada não permite pets. 😣'
    end
  end
end
