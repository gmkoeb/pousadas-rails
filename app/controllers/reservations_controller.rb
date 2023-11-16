class ReservationsController < ApplicationController
  include ReservationsHelper
  
  before_action :admin_has_inn?
  before_action :authenticate_admin!, only: [:active, :check_in]
  before_action :set_room_and_check_availability, :set_inn_time, only: [:new, :create, :check]
  before_action :authenticate_user!, only: [:create, :show, :index]
  before_action :store_location, only: [:check]

  def index
    user_reservations = current_user.reservations
    user_room_reservations = current_user.rooms.joins(:reservations)
    if user_reservations.empty? && current_user.admin == false
      return redirect_to root_path, alert: 'Você não possui nenhuma reserva.' 
    elsif user_room_reservations.empty? && current_user.admin
      return redirect_to root_path, alert: 'Você não possui nenhuma reserva.'
    elsif current_user.admin?
      @past_reservations = Reservation.where(room: current_user.rooms).not_pending.not_active
      @valid_reservations = Reservation.where(room: current_user.rooms).not_finished.not_canceled
    else
      @past_reservations = current_user.reservations.not_pending.not_active
      @valid_reservations = current_user.reservations.not_finished.not_canceled
    end
  end

  def active
    @reservations = Reservation.where(room: current_user.rooms).active
  end

  def new
    @reservation = @room.reservations.build
    @session_params = session[:params]
  end

  def create
    session[:params] = nil
    reservation_params = params.require(:reservation).permit(:guests, :check_in, :check_out, :total_price)
    reservation_params[:check_out] = set_checkout_time(@inn_standard_time, reservation_params[:check_out])
    reservation_params[:check_in] = set_checkin_time(@inn_standard_time, reservation_params[:check_in])

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
    @check_out_date = set_checkout_time(@inn_standard_time, params[:check_out])
    @check_in_date = set_checkin_time(@inn_standard_time, params[:check_in])
    @guests = params[:guests]
    @total_price = calculate_price(@check_in_date, @check_out_date)

    reservation_params = { guests: @guests, check_in: @check_in_date, check_out: 
                           @check_out_date, total_price: @total_price }
    
    @reservation = @room.reservations.build(reservation_params)
    @reservation.user = @inn.user
    if @reservation.valid?
      session[:params] = reservation_params
      render 'new'
    else
      render 'new'
    end
  end

  def show
    @reservation = Reservation.friendly.find(params[:id])
    @room = @reservation.room
    @room_owner = @room.inn.user 
    unless current_user == @reservation.user || current_user == @room_owner
      return redirect_to root_path, alert: 'Acesso negado' 
    end
  end

  def cancel
    @reservation = Reservation.friendly.find(params[:id])
    room_owner = @reservation.room.inn.user
    if @reservation.check_in < 7.days.from_now && current_user != room_owner
      return redirect_to root_path, alert: 'Você não pode cancelar essa reserva' 
    end
    @reservation.room.published!
    @reservation.canceled!
    redirect_to reservations_path
  end

  def check_in
    @reservation = Reservation.friendly.find(params[:id])
    check_in_time = @reservation.check_in
    if DateTime.now > check_in_time + 2.days || DateTime.now < check_in_time
      return redirect_to reservation_path(@reservation), alert: 'Não foi possível realizar o check-in.' 
    else
      @reservation.update(check_in: DateTime.now, status: 'active')
      redirect_to reservation_path(@reservation), notice: 'Check-in realizado com sucesso!'
    end
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