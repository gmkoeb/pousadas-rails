module ReservationsHelper
  def current_price_per_period(room)
    special_price = []
    room.price_per_periods.each do |price_per_period|
      if Date.current.between?(price_per_period.starts_at, price_per_period.ends_at)
        special_price = price_per_period
      end
    end
    special_price
  end

  def a_week_from_check_in_date(check_in)
    7.days.from_now.change(hour: check_in.hour, min: check_in.min)
  end

  def color_by_status(status)
    case status
    when 'pending'
      'text-warning'
    when 'canceled'
      'text-danger'
    when 'active'
      'text-success'
    else
      'text-info'
    end
  end
end