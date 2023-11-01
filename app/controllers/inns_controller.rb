class InnsController < ApplicationController
  def new
    if current_user.admin?
      @inn = Inn.new
    else
      redirect_to root_path, notice: 'Você precisa ser um dono de pousadas para acessar essa página.'
    end
  end

  def create
    inn_params = params.require(:inn).permit(:corporate_name, :brand_name, 
                                             :registration_number, :phone, :email, 
                                             :address, :district, :state, :city,
                                             :zip_code, :description, :accepts_pets, :terms_of_service, 
                                             :check_in_check_out_time, payment_methods:[])
    @inn = Inn.new(inn_params)

    @inn.user = current_user

    if @inn.save
      redirect_to inn_path(@inn.slug), notice: 'Pousada cadastrada com sucesso! 😊'
    else  
      flash.now[:notice] = 'Não foi possível cadastrar pousada. 😢'
      render 'new', status: 422
    end
  end

  def show     
    @inn = Inn.friendly.find(params[:id])
  end

  def edit
    @inn = Inn.friendly.find(params[:id])
    if current_user == @inn.user
      render
    else
      redirect_to root_path, notice: "Você só pode editar as suas pousadas."
    end
  end

  def update
    @inn = Inn.friendly.find(params[:id])
    inn_params = params.require(:inn).permit(:corporate_name, :brand_name, 
                                             :registration_number, :phone, :email, 
                                             :address, :district, :state, :city,
                                             :zip_code, :description, :accepts_pets, :terms_of_service, 
                                             :check_in_check_out_time, payment_methods:[])
    if @inn.update(inn_params)
      redirect_to inn_path(@inn.slug), notice: 'Pousada atualizada com sucesso! 😊'
    else
      flash.now[:notice] = 'Não foi possível atualizar a pousada. 😢'
      render 'edit'
    end
  end
end