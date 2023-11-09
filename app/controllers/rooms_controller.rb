class RoomsController < ApplicationController
  before_action :admin_has_inn?
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :publish, :draft]
  before_action :set_inn, only: [:new, :create, :index]
  before_action :inn_belongs_to_user?, only:[:new, :create]
  before_action :room_params, only: [:create, :update]
  before_action :set_room_and_check_user, only: [:edit, :update, :draft, :publish]

  def new
    @room = @inn.rooms.build
  end

  def create                                             
    @room = @inn.rooms.build(room_params)
    if @room.save
      redirect_to room_path(@room), notice: 'Quarto cadastrado com sucesso!'
    else
      flash.now[:alert] = "Não foi possível cadastrar o quarto."
      render 'new', status: 422
    end                       
  end

  def index
    if current_user
      if current_user.inn == @inn
        @rooms = @inn.rooms
      end
    else
      @rooms = @inn.rooms.published
    end
  end

  def show
    @room = Room.friendly.find(params[:id])
    if @room.draft?
      if current_user.nil? || current_user.inn != @room.inn
        redirect_to inn_path(@room.inn), alert: 'Este quarto não está aceitando reservas no momento.'
      end
    end
  end

  def edit
  end

  def update
    if @room.update(room_params)
      redirect_to room_path(@room), notice: 'Quarto atualizado com sucesso!'     
    else
      flash.now[:alert] = 'Não foi possível atualizar o quarto.'  
      render 'edit', status: 422
    end                                  
  end

  def publish
    @room.published!
    redirect_to room_path(@room)
  end

  def draft
    @room.draft!
    redirect_to room_path(@room)
  end

  private

  def set_inn
    @inn = Inn.friendly.find(params[:inn_id])
  end

  def set_room_and_check_user
    @room = Room.friendly.find(params[:id])
    user_room = current_user.inn.rooms.where(id: @room.id)
    if user_room.empty?
      redirect_to root_path, alert: 'Você não pode realizar essa ação'
    end
  end

  def room_params
    room_params = params.require(:room).permit(:name, :description, :area, 
                                               :maximum_guests, :price, :has_bathroom, 
                                               :has_balcony, :has_air_conditioner, :has_tv,
                                               :has_wardrobe, :has_coffer, :accessible)
  end
end