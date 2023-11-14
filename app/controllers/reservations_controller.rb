class ReservationsController < ApplicationController
  before_action :admin_has_inn?
  before_action :set_room_and_check_availability, only: [:new, :create, :check]
  before_action :authenticate_user!, only: [:create]
  before_action :store_location, only: [:check]

  def new
    @reservation = @room.reservations.build
  end

  def create
    reservation_params = params.require(:reservation).permit(:guests, :check_in, :check_out, :total_price)
    @reservation = @room.reservations.build(reservation_params)
    @reservation.user = current_user
    if @reservation.save
      @room.draft!
      redirect_to reservation_path(@reservation), notice: 'Reserva efetuada com sucesso.'
    else
      flash.now[:alert] = "Não foi possível realizar reserva."
      render 'new', status: 422
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

  def show
    @reservation = Reservation.find(params[:id])
  end

  private

  def store_location
    session[:user_return_to] = new_room_reservation_path(@room)
  end
  
  def set_room_and_check_availability 
    @room = Room.friendly.find(params[:room_id])
    if @room.draft?
      redirect_to inn_path(@room.inn), 
      alert: 'Este quarto não está aceitando reservas no momento.' if current_user.nil? || current_user.rooms.exclude?(@room)
    end
  end
end