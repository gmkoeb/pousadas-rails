class Api::V1::RoomsController < Api::V1::ApiController
  def index
    inn = Inn.find(params[:inn_id]) 
    rooms = inn.rooms.published
    render status: 200, json: rooms.as_json(except: [:picture])
  end

  def check
    room = Room.find(params[:room_id])
    reservation_params = params.require(:reservation_details).permit(:check_in, :check_out, :guests)
    consumables = []
    total_price = Reservation.calculate_price(reservation_params[:check_in], reservation_params[:check_out], room.price, room.price_per_periods, consumables)
    reservation = room.reservations.build(reservation_params)
    if reservation.valid?
      render status: 200, json:{ "total_price" => total_price, "room" => room.id }
    else
      render status: 406, json: { errors: reservation.errors.full_messages }
    end
  end

  private

  def return_500
    render status: 500, json: { error: 'Active record error' }
  end

  def return_404
    render status: 404, json: { error: 'Record not found' }
  end
end