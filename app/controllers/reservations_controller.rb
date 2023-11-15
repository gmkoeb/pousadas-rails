class ReservationsController < ApplicationController
  include ReservationsHelper
  
  before_action :admin_has_inn?
  before_action :set_room_and_check_availability, :set_inn_time, only: [:new, :create, :check]
  before_action :authenticate_user!, only: [:create, :show]
  before_action :store_location, only: [:check]

  def index
    user_reservations = current_user.reservations
    return redirect_to root_path, alert: 'Você não possui nenhuma reserva.' if user_reservations.empty?
    @finished_reservations,
    @canceled_reservations = user_reservations.finished,
                             user_reservations.canceled
    @valid_reservations = Reservation.all.not_finished.not_canceled
  end

  def new
    @reservation = @room.reservations.build
  end

  def create
    reservation_params = params.require(:reservation).permit(:guests, :check_in, :check_out, :total_price)
    reservation_params[:check_out] = set_checkout_time(@inn_standard_time, reservation_params[:check_out])
    reservation_params[:check_in] = set_checkin_time(@inn_standard_time, reservation_params[:check_in])
    @reservation = @room.reservations.build(reservation_params)
    @reservation.user = current_user
    if @reservation.save
      redirect_to reservation_path(@reservation), notice: 'Reserva efetuada com sucesso.'
    else
      flash.now[:alert] = "Não foi possível realizar reserva."
      render 'new', status: 422
    end
  end

  def check
    @check_out_date = set_checkout_time(@inn_standard_time, params[:check_out])
    @check_in_date = set_checkin_time(@inn_standard_time, params[:check_in])
    @guests = params[:guests]
    
    @reservation = @room.reservations.build(guests: @guests, check_in: @check_in_date, check_out: @check_out_date)
    @reservation.user = @inn.user
    if @reservation.valid?
      @total_price = calculate_price(@check_in_date, @check_out_date)
      render 'new'
    else
      render 'new'
    end
  end

  def show
    @reservation = Reservation.friendly.find(params[:id])
    @room = @reservation.room
    room_owner = @room.inn.user 
    unless current_user == @reservation.user || current_user == room_owner
      return redirect_to root_path, alert: 'Acesso negado' 
    end
  end

  def cancel
    @reservation = Reservation.friendly.find(params[:id])
    @reservation.canceled!
    redirect_to reservations_path
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

  def set_inn_time
    @inn = @room.inn
    @inn_standard_time = @inn.check_in_check_out_time
  end
end