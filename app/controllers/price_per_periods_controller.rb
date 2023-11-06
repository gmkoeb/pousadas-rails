class PricePerPeriodsController < ApplicationController
  before_action :set_room, :set_inn, :authenticate_admin!, :admin_has_inn?, :inn_belongs_to_user?

  def new
    @price_per_period = @room.price_per_periods.build
  end

  def create
    price_per_period_params = params.require(:price_per_period).permit(:special_price, :starts_at, :ends_at)

    room = @inn.rooms.find(@room.id)

    @price_per_period = room.price_per_periods.build(price_per_period_params)

    if @price_per_period.save
      redirect_to inn_room_path(@inn, room), notice: 'Preço por período cadastrado com sucesso.'
    else
      flash.now[:alert] = "Não foi possível cadastrar preço especial."
      render 'new', status: 422
    end
  end

  def destroy
    @price_per_period = PricePerPeriod.find(params[:id])
    @price_per_period.delete
    redirect_to inn_room_path(@inn, @room), notice: 'Preço especial removido com sucesso.'
  end

  private

  def set_room
    @room = Room.friendly.find(params[:room_id])
  end

  def set_inn
    @inn = current_user.inn
  end
end