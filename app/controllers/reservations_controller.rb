class ReservationsController < ApplicationController
  before_action :admin_has_inn?, :set_room
  before_action :store_location

  def new
    @reservation = @room.reservations.build
  end

  def create
    authenticate_user!
    reservation_params = params.require(:reservation).permit(:guests, :check_in, :check_out)
    @reservation = @room.reservations.build(reservation_params)
    @reservation.total_price = @total_price
    @reservation.user = current_user
    if @reservation.save
      redirect_to reservations_path, notice: 'Reserva efetuada com sucesso.'
    else
      render 'new'
    end
  end

  def check
    @check_out_date = params[:check_out].to_date
    @check_in_date = params[:check_in].to_date
    @guests = params[:guests]
    @reservation = @room.reservations.build(guests: @guests, check_in: @check_in_date, check_out: @check_out_date)
    @reservation.user = @room.inn.user

    if @reservation.valid?
      @total_price = @room.price*(@check_out_date-@check_in_date).to_i 
      render 'new'
    else
      render 'new'
    end
  end

  private
  def set_room
    @room = Room.friendly.find(params[:room_id])
  end

  def store_location
    session[:user_return_to] = new_room_reservation_path(@room)
  end
  
end