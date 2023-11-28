class ConsumablesController < ApplicationController
  before_action :authenticate_admin!, :admin_has_inn?

  def new
    @reservation = Reservation.friendly.find(params[:reservation_id])
    return redirect_to root_path, alert: 'Reserva deve estar ativa' if !@reservation.active?
    @consumable = @reservation.consumables.build
  end

  def create
    consumable_params = params.require(:consumable).permit(:name, :value)
    @reservation = Reservation.friendly.find(params[:reservation_id])
    return redirect_to root_path, alert: 'Reserva deve estar ativa' if !@reservation.active?
    @consumable = @reservation.consumables.build(consumable_params)
    if @consumable.save
      return redirect_to @reservation, notice: 'Consumível adicionado com sucesso'
    else
      flash.now[:alert] = 'Não foi possível adicionar consumível'
      render 'new', status: 422
    end
  end
end