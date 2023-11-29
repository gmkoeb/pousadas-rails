class ReservationGuestsController < ApplicationController
  before_action :authenticate_admin!, :admin_has_inn?, :check_user_and_set_reservation
  def create
    @valid_guests = []
    reservation_guest_params = params.require(:reservation_guest).permit(name: [], registration_number: [], age: [])
    reservation_guest_params[:name].each_with_index do |name, index|
      @reservation_guest = @reservation.reservation_guests.build(name: name, 
                                                                registration_number: reservation_guest_params[:registration_number][index],
                                                                age: reservation_guest_params[:age][index])
      if @reservation_guest.valid?
        @valid_guests << @reservation_guest
        @reservation_guest.save
      else
        flash[:alert] = "Não foi possível registrar convidados"
        return render 'reservations/check_in_form'
      end
    end

    if @valid_guests.length == @reservation.guests - 1
      flash[:notice] = 'Hóspedes acompanhantes cadastrados com sucesso!'
      render 'reservations/check_in_form'
    end
  end

  private
  
  def check_user_and_set_reservation
    @reservation = Reservation.friendly.find(params[:reservation_id])
    inn = @reservation.room.inn
    return redirect_to root_path, alert: 'Você não pode realizar essa ação.' if current_user.inn != inn
  end
end
