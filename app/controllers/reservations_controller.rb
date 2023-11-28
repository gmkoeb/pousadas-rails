class ReservationsController < ApplicationController
  before_action :admin_has_inn?
  before_action :authenticate_admin!, only: [:active, :check_in, :check_out, :check_out_form]
  before_action :set_room_and_check_availability, only: [:new, :create, :check]
  before_action :authenticate_user!, only: [:create, :show, :index]
  before_action :store_location, only: [:check]
  before_action :set_reservation, only: [:check_out_form, :show, :check_in, :check_out, :cancel]
  before_action :calculate_reservation_price, only: [:check_out_form, :check_out]
  before_action :check_user, only: [:check_in, :check_out, :check_out_form]

  def index
    if current_user.admin
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
    session[:params] = session[:params].transform_keys { |keys| keys.to_sym } if session[:params]
  end

  def create
    reservation_params = session[:params]
    inn_time = @room.check_in_check_out_time
    reservation_params[:check_in] = standardize_time(inn_time, reservation_params["check_in"])
    reservation_params[:check_out] = standardize_time(inn_time, reservation_params["check_out"])
    @reservation = @room.reservations.build(reservation_params)
    @reservation.user = current_user
    if @reservation.save
      @room.draft!
      session[:params] = nil
      redirect_to reservation_path(@reservation), notice: 'Reserva efetuada com sucesso.'
    else
      return redirect_to root_path, alert: "Não foi possível realizar reserva."
    end
  end

  def check
    guests = params[:guests]
    consumables = []
    inn_time = @room.check_in_check_out_time
    check_in_date = standardize_time(inn_time, params[:check_in])
    check_out_date = standardize_time(inn_time, params[:check_out])
    total_price = Reservation.calculate_price(check_in_date, check_out_date, @room.price, @room.price_per_periods, consumables)

    reservation_params = { guests: guests, check_in: check_in_date, 
                           check_out: check_out_date, total_price: total_price } 
    
    @reservation = @room.reservations.build(reservation_params)
    
    if @reservation.valid?
      session[:params] = reservation_params
      render 'new'
    else
      render 'new'
    end
  end

  def show
    @room = @reservation.room
    @room_owner = @room.inn.user 
    @review = @reservation.review
    @consumables = @reservation.consumables
    unless current_user == @reservation.user || current_user == @room_owner
      return redirect_to root_path, alert: 'Acesso negado' 
    end
  end

  def cancel
    room_owner = @reservation.room.inn.user
    if @reservation.check_in < 7.days.from_now && current_user != room_owner
      return redirect_to root_path, alert: 'Você não pode cancelar essa reserva' 
    end
    @reservation.room.published!
    @reservation.canceled!
    redirect_to reservations_path
  end

  def check_in
    check_in_time = @reservation.check_in 
    if Time.zone.now > check_in_time + 2.days || Time.zone.now < check_in_time
      return redirect_to reservation_path(@reservation), alert: 'Não foi possível realizar o check-in.' 
    else
      @reservation.update(check_in: Time.zone.now, status: 'active')
      redirect_to reservation_path(@reservation), notice: 'Check-in realizado com sucesso!'
    end
  end

  def check_out_form
    return redirect_to reservation_path(@reservation), alert: 'Acesso negado.' unless @reservation.active?
    @payment_methods = eval(@room.payment_methods)
  end

  def check_out
    check_out_params = { payment_method: params[:payment_method], 
                         total_price: @total_price, check_out: Time.zone.now }
    if @reservation.update(check_out_params)
      @reservation.finished!
      @reservation.room.published!
      return redirect_to reservation_path(@reservation), notice: 'Check-Out realizado com sucesso!'
    else
      redirect_to check_out_form_reservation_path(@reservation), alert: 'Não foi possível realizar o check-out.'
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

  def set_reservation
    @reservation = Reservation.friendly.find(params[:id])
  end

  def calculate_reservation_price
    @room = @reservation.room
    @total_price = Reservation.calculate_price(@reservation.check_in, Time.zone.now, @room.price, @room.price_per_periods, @reservation.consumables)
    if Time.zone.now > @reservation.check_out || Time.zone.now.day == @reservation.check_in.day
      @total_price = Reservation.calculate_price(@reservation.check_in, Time.zone.now.to_date.tomorrow, @room.price, @room.price_per_periods, @reservation.consumables)
    end
  end

  def standardize_time(inn_time, reservation_time)
    reservation_time.in_time_zone.change(hour: inn_time.hour, min: inn_time.min) if reservation_time
  end

  def check_user
    inn = @reservation.room.inn
    return redirect_to root_path, alert: 'Você não pode realizar essa ação.' if current_user.inn != inn
  end

end