module ReservationsHelper
  def calculate_price(checkin, checkout)
    reservation_days = (checkout.to_date - checkin.to_date).to_i
    @total_price = @room.price * reservation_days
    prices_per_periods = @room.price_per_periods
    if prices_per_periods.any?
      prices_per_periods.each do |price_per_period|
        special_price_duration = Range.new(price_per_period.starts_at, price_per_period.ends_at)
        reservation_duration = Range.new(checkin.to_date, checkout.to_date)
        if special_price_duration.any?(reservation_duration)
          if price_per_period.ends_at <= checkout.to_date
            special_price_remaining_duration = Range.new(checkin.to_date, price_per_period.ends_at)
            @total_price = price_per_period.special_price * (special_price_remaining_duration.count) + @room.price * (checkout.to_date - price_per_period.ends_at).to_i
          else
            @total_price = price_per_period.special_price * reservation_days
          end
        end
      end
    end
    @total_price
  end

  def set_checkin_time(inn_time, reservation_checkin)
    total_time = inn_time.hour * 3600 + inn_time.min * 60
    return if reservation_checkin.in_time_zone.nil?

    reservation_checkin = reservation_checkin.in_time_zone + total_time
  end

  def set_checkout_time(inn_time, reservation_checkout)
    total_time = inn_time.hour * 3600 + inn_time.min * 60
    return if reservation_checkout.in_time_zone.nil?
    
    reservation_checkout = reservation_checkout.in_time_zone + total_time
  end

  def current_price_per_period(room)
    room.price_per_periods.each do |price_per_period|
      if Date.today.between?(price_per_period.starts_at, price_per_period.ends_at)
        price_per_period
      end
    end
  end
end