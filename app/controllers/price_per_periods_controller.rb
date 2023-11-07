class PricePerPeriodsController < ApplicationController
  before_action :authenticate_admin!, :admin_has_inn?, :inn_room_belongs_to_user?

  def new
    @price_per_period = @room.price_per_periods.build
  end

  def create
    price_per_period_params = params.require(:price_per_period).permit(:special_price, :starts_at, :ends_at)

    @price_per_period = @room.price_per_periods.build(price_per_period_params)

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

  def inn_room_belongs_to_user?
    @room = Room.friendly.find(params[:room_id])
    user_room = current_user.inn.rooms.where(slug: params[:room_id])
    if user_room.empty?
      redirect_to root_path, alert: 'Você não pode realizar essa ação'
    end
  end
end