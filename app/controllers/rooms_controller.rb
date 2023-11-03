class RoomsController < ApplicationController
  before_action :set_inn, :admin_has_inn?
  before_action :authenticate_admin!, :inn_belongs_to_user?, only: [:new, :create, :edit, :update]
  def new
    @room = @inn.rooms.build
  end

  def create
    room_params = params.require(:room).permit(:name, :description, :area, 
                                                :maximum_guests, :price, :has_bathroom, 
                                                :has_balcony, :has_air_conditioner, :has_tv,
                                                :has_wardrobe, :has_coffer, :accessible)
                                                
    inn = current_user.inn          

    @room = inn.rooms.build(room_params)
    if @room.save
      redirect_to inn_rooms_path, notice: 'Quarto cadastrado com sucesso!'
    else
      flash.now[:notice] = "Não foi possível cadastrar o quarto."
      render 'new', status: 422
    end                       
  end

  def index
    @rooms = @inn.rooms
  end

  def show
    @room = Room.friendly.find(params[:id])
  end

  def edit
    @room = Room.friendly.find(params[:id])
  end

  def update
    @room = Room.friendly.find(params[:id])
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
  private

  def set_inn
    @inn = Inn.friendly.find(params[:inn_id])
  end

  def inn_belongs_to_user?
    if current_user.inn != @inn
      redirect_to root_path, notice: 'Você não pode realizar essa ação'
    end
  end
end