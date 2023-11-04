class RoomsController < ApplicationController
  before_action :admin_has_inn?, :set_inn
  before_action :authenticate_admin!, :inn_belongs_to_user?, only: [:new, :create, :edit, :update]
  before_action :room_params, only: [:create, :update]
  before_action :set_room, only: [:show, :edit, :update, :publish, :draft]
  def new
    @room = @inn.rooms.build
  end

  def create                                                
    @room = current_user.inn.rooms.build(room_params)
    if @room.save
      redirect_to inn_rooms_path, notice: 'Quarto cadastrado com sucesso!'
    else
      flash.now[:notice] = "Não foi possível cadastrar o quarto."
      render 'new', status: 422
    end                       
  end

  def index
    if current_user && current_user.admin?
      @rooms = @inn.rooms
    else
      @rooms = @inn.rooms.published
    end
  end

  def show
    @room = Room.friendly.find(params[:id])
    if @room.draft?
      if current_user.nil? || current_user.inn != @inn
        redirect_to inn_rooms_path(@inn), notice: 'Este quarto não está aceitando reservas no momento.'
      end
    end
  end

  def edit;end

  def update
    room_params = params.require(:room).permit(:name, :description, :area, 
                                               :maximum_guests, :price, :has_bathroom, 
                                               :has_balcony, :has_air_conditioner, :has_tv,
                                               :has_wardrobe, :has_coffer, :accessible)
    if @room.update(room_params)
      redirect_to inn_room_path(@inn, @room), notice: 'Quarto atualizado com sucesso!'     
    else
      flash.now[:notice] = 'Não foi possível atualizar o quarto.'  
      render 'edit', status: 422
    end                                  
  end

  def publish
    @room.published!
    redirect_to inn_room_path(@inn, @room)
  end

  def draft
    @room.draft!
    redirect_to inn_room_path(@inn, @room)
  end

  private

  def set_inn
    @inn = Inn.friendly.find(params[:inn_id])
  end

  def set_room
    @room = Room.friendly.find(params[:id])
  end

  def inn_belongs_to_user?
    if current_user.inn != @inn
      redirect_to root_path, notice: 'Você não pode realizar essa ação'
    end
  end

  def room_params
    room_params = params.require(:room).permit(:name, :description, :area, 
                                               :maximum_guests, :price, :has_bathroom, 
                                               :has_balcony, :has_air_conditioner, :has_tv,
                                               :has_wardrobe, :has_coffer, :accessible)
  end
end