class InnsController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :publish, :draft]
  before_action :admin_has_inn?, except: [:new, :create]
  before_action :set_inn_and_check_user, only: [:edit, :update, :publish, :draft]
  before_action :inn_params, only: [:create, :update]

  
  def new
    @inn = Inn.new
  end

  def create
    @inn = Inn.new(inn_params)
    @inn.user = current_user
    if @inn.save
      redirect_to inn_path(@inn), notice: 'Pousada cadastrada com sucesso!'
    else  
      @inn.user = nil
      flash.now[:alert] = 'Não foi possível cadastrar pousada.'
      render 'new', status: 422
    end
  end

  def show     
    @inn = Inn.friendly.find(params[:id])

    if @inn.draft?
      unless current_user && current_user.inn == @inn
        redirect_to root_path, notice: 'Essa pousada não está aceitando reservas no momento.'
      end
    end

    if @inn.rooms.present?
      @rooms = @inn.rooms.published
    end
  end

  def edit;end

  def update
    if @inn.update(inn_params)
      redirect_to inn_path(@inn), notice: 'Pousada atualizada com sucesso!'
    else
      flash.now[:alert] = 'Não foi possível atualizar a pousada.'
      render 'edit', status: '422'
    end
  end

  def publish
    @inn.published!
    redirect_to inn_path(@inn)
  end

  def draft
    @inn.draft!
    redirect_to inn_path(@inn)
  end

  def search_by_city
    @city = params[:city]
    @inns = Inn.where(city: @city).sort_inns
  end

  def advanced_search_form
  end
  
  def search
    @query = params[:query]
    @inns = Inn.search(@query)
  end

  def advanced_search
    @accepts_pets = params[:accepts_pets]
    @query = params[:query]
    @payment_methods = params[:payment_methods]
    @room_infos = params[:room_infos]
    @inns = Inn.advanced_search(@query, @accepts_pets, @payment_methods, @room_infos)
  end

  private

  def inn_params
    inn_params = params.require(:inn).permit(:corporate_name, :brand_name, 
                                             :registration_number, :phone, :email, 
                                             :address, :district, :state, :city,
                                             :zip_code, :description, :accepts_pets, :terms_of_service, 
                                             :check_in_check_out_time, payment_methods:[])
  end

  def set_inn_and_check_user
    @inn = Inn.friendly.find(params[:id])
    if current_user
      return redirect_to root_path, alert: 'Você não pode realizar essa ação.' if current_user.inn != @inn
    end
  end
end