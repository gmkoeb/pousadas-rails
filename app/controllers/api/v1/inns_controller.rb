class Api::V1::InnsController < Api::V1::ApiController
  def index
    inns = Inn.all.published
    query = params[:query]
    if query
      inns = Inn.all.published.where("brand_name LIKE ?", "%#{query}%")
    end
    return render status: 200, json: inns.as_json(except: [:picture])
  end

  def show
    inn = Inn.find(params[:id])
    formatted_time = inn.check_in_check_out_time.strftime('%H:%M')
    return render status: 200, json: inn.as_json(except: [:registration_number, :corporate_name, :picture]).merge({ formatted_time: formatted_time })
  end

  private

  def return_500
    return render status: 500, json: { error: 'Active record error' }
  end

  def return_404
    return render status: 404, json: { error: 'Record not found' }
  end
end