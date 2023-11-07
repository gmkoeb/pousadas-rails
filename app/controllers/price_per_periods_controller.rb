class PricePerPeriodsController < ApplicationController
  before_action :authenticate_admin!, :admin_has_inn?, :set_inn, :inn_belongs_to_user?, :set_room

  def new
    @price_per_period = @room.price_per_periods.build
  end

  def create
    price_per_period_params = params.require(:price_per_period).permit(:special_price, :starts_at, :ends_at)

    @price_per_period = @inn.rooms.friendly.find(params[:room_id]).price_per_periods.build(price_per_period_params)

    if @price_per_period.save
      redirect_to room_path(@room), notice: 'Preço por período cadastrado com sucesso.'
    else
      flash.now[:alert] = "Não foi possível cadastrar preço especial."
      render 'new', status: 422
    end
  end

  def destroy
    @price_per_period = PricePerPeriod.find(params[:id])
    @price_per_period.delete
    redirect_to room_path(@room), notice: 'Preço especial removido com sucesso.'
  end

  private
  def set_inn
    @inn = current_user.inn
  end

  def set_room
    @room = Room.friendly.find(params[:room_id])
  end
end