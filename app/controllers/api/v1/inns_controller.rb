class Api::V1::InnsController < Api::V1::ApiController
  def index
    inns = Inn.all.published
    query = params[:query]
    if query
      inns = Inn.all.published.where("brand_name LIKE ?", "%#{query}%")
    end
    render status: 200, json: inns
  end

  def show
    inn = Inn.find(params[:id])
    formatted_time = inn.check_in_check_out_time.strftime('%H:%M')
    render status: 200, json: inn.as_json(except: [:registration_number, :corporate_name]).merge({ formatted_time: formatted_time })
  end

  private

  def return_500
    render status: 500, json: { error: 'Active record error' }
  end

  def return_404
    render status: 404, json: { error: 'Record not found' }
  end
end