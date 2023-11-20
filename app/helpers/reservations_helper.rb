module ReservationsHelper
  def calculate_price(check_in, check_out, standard_price, price_per_periods)
    return if check_in.nil? || check_out.nil?
    reservation_days = (check_out.to_date - check_in.to_date).to_i
    total_price = standard_price * reservation_days
    if price_per_periods.any?
      price_per_periods.each do |price_per_period|
        special_price_duration = Range.new(price_per_period.starts_at, price_per_period.ends_at)
        reservation_duration = Range.new(check_in.to_date, check_out.to_date)
        if special_price_duration.any?(reservation_duration)
          if price_per_period.ends_at <= check_out.to_date
            special_price_remaining_duration = Range.new(check_in.to_date, price_per_period.ends_at)
            total_price = price_per_period.special_price * (special_price_remaining_duration.count) + @room.price * (check_out.to_date - price_per_period.ends_at).to_i
          else
            total_price = price_per_period.special_price * reservation_days
          end
        end
      end
    end
    total_price
  end

  def standardize_check_in_time(inn_time, reservation_check_in)
    return if reservation_check_in.in_time_zone.nil?

    reservation_check_in.in_time_zone.change(hour: inn_time.hour, min: inn_time.min)
  end

  def standardize_check_out_time(inn_time, reservation_check_out)
    return if reservation_check_out.in_time_zone.nil?
    
    reservation_check_out.in_time_zone.change(hour: inn_time.hour, min: inn_time.min)
  end

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
end