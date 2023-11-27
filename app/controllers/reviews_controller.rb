class ReviewsController < ApplicationController
  before_action :authenticate_user!, :admin_has_inn?

  def index
    if current_user.admin?
      @reviews = current_user.inn.reviews
    else
      @reviews = current_user.reviews
    end
  end

  def create
    @reservation = Reservation.friendly.find(params[:reservation_id])
    return redirect_to reservation_path(@reservation) unless @reservation.finished?
    review_params = params.require(:review).permit(:text, :grade, :reservation_id)
    @review = @reservation.build_review(review_params)
    @review.user_id = @reservation.user_id
    if @review.save
      return redirect_to @reservation, notice: "Avaliação enviada com sucesso!"
    else
      return redirect_to @reservation, alert: "Não foi possível enviar avaliação."
    end
  end

  def update
    @review = Review.find(params[:id])
    review_params = params.require(:review).permit(:answer)
    if @review.update(review_params)
      return redirect_to @review.reservation, notice: "Resposta enviada com sucesso!"
    end
  end
end