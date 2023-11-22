class ReviewsController < ApplicationController
  def create
    @reservation = Reservation.friendly.find(params[:reservation_id])
    review_params = params.require(:review).permit(:review_text, :review_grade, :reservation_id)
    @review = @reservation.reviews.build(review_params)
    @review.user_id = @reservation.user_id
    if @reservation.save
      return redirect_to @reservation, notice: "Avaliação enviada com sucesso!"
    else
      return redirect_to @reservation, alert: "Não foi possível enviar avaliação."
    end
  end
end