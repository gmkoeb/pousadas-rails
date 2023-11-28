class ConsumablesController < ApplicationController
  before_action :authenticate_admin!, :admin_has_inn?, :check_user_and_set_reservation

  def new
    return redirect_to root_path, alert: 'Reserva deve estar ativa' if !@reservation.active?
    @consumable = @reservation.consumables.build
  end

  def create
    return redirect_to root_path, alert: 'Reserva deve estar ativa' if !@reservation.active?
    consumable_params = params.require(:consumable).permit(:name, :value)
    @consumable = @reservation.consumables.build(consumable_params)
    if @consumable.save
      return redirect_to @reservation, notice: 'Consumível adicionado com sucesso'
    else
      flash.now[:alert] = 'Não foi possível adicionar consumível'
      render 'new', status: 422
    end
  end

  private

  def check_user_and_set_reservation
    @reservation = Reservation.friendly.find(params[:reservation_id])
    inn = @reservation.room.inn
    if current_user
      return redirect_to root_path, alert: 'Você não pode realizar essa ação.' if current_user.inn != inn
    end
  end

end