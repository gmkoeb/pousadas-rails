class InnsController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :publish, :draft]
  before_action :admin_has_inn?, except: [:new, :create]
  before_action :set_inn, only: [:show, :edit, :update, :publish, :draft]
  before_action :inn_params, only: [:create, :update]
  before_action :inn_belongs_to_user?, only: [:edit, :update, :publish, :draft]
  
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
    if @inn.draft?
      if current_user.nil? || current_user.inn != @inn
        redirect_to root_path, notice: 'Essa pousada não está aceitando reservas no momento.'
      end
    end
  end

  def edit;end

  def update
    inn_params = params.require(:inn).permit(:corporate_name, :brand_name, 
                                             :registration_number, :phone, :email, 
                                             :address, :district, :state, :city,
                                             :zip_code, :description, :accepts_pets, :terms_of_service, 
                                             :check_in_check_out_time, payment_methods:[])
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
    @inns = Inn.where(city: @city).published.sort_by { |inn| inn[:brand_name] }
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
    @price = params[:price]
    @inns = Inn.advanced_search(@query, @accepts_pets, @payment_methods, @room_infos, @price)
  end

  private

  def set_inn
    @inn = Inn.friendly.find(params[:id])
  end

  def inn_params
    inn_params = params.require(:inn).permit(:corporate_name, :brand_name, 
                                             :registration_number, :phone, :email, 
                                             :address, :district, :state, :city,
                                             :zip_code, :description, :accepts_pets, :terms_of_service, 
                                             :check_in_check_out_time, payment_methods:[])
  end
end