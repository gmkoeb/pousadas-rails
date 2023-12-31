class RoomsController < ApplicationController
  before_action :admin_has_inn?
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :publish, :draft]
  before_action :set_inn_and_check_user, only: [:new, :create, :index]
  before_action :room_params, only: [:create, :update]
  before_action :set_room_and_check_user, only: [:edit, :update, :draft, :publish]

  def new
    @room = current_user.rooms.build
  end

  def create                                             
    @room = current_user.rooms.build(room_params)
    if @room.save
      redirect_to @room, notice: 'Quarto cadastrado com sucesso!'
    else
      flash.now[:alert] = "Não foi possível cadastrar o quarto."
      render 'new', status: 422
    end                       
  end

  def index
    @rooms = @inn.rooms.published   
    @rooms = current_user.rooms if current_user.inn == @inn
  end

  def show
    @room = Room.friendly.find(params[:id])
    @gallery_pictures = @room.gallery_pictures
    if @room.draft?
      redirect_to inn_path(@room.inn), 
      alert: 'Este quarto não está aceitando reservas no momento.' if current_user.nil? || current_user.rooms.exclude?(@room)
    end
  end

  def edit;end

  def update
    if @room.update(room_params)
      redirect_to @room, notice: 'Quarto atualizado com sucesso!'     
    else
      flash.now[:alert] = 'Não foi possível atualizar o quarto.'  
      render 'edit', status: 422
    end                                  
  end

  def publish
    @room.published!
    redirect_to @room
  end

  def draft
    @room.draft!
    redirect_to @room
  end

  private

  def set_inn_and_check_user
    @inn = Inn.friendly.find(params[:inn_id])
    return redirect_to root_path, alert: 'Você não pode realizar essa ação.' if current_user.inn != @inn
  end

  def set_room_and_check_user
    @room = Room.friendly.find(params[:id])
    redirect_to root_path, alert: 'Você não pode realizar essa ação' if current_user.rooms.exclude?(@room)
  end

  def room_params
    room_params = params.require(:room).permit(:name, :description, :area, 
                                               :maximum_guests, :price, :has_bathroom, 
                                               :has_balcony, :has_air_conditioner, :has_tv,
                                               :has_wardrobe, :has_coffer, :accessible, :picture)
  end
end