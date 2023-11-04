module InnsHelper
  private
  def accepted_payment(method)
    return false unless @inn
    return false if @inn.payment_methods.nil?

    @inn.payment_methods.include? method
  end
end
