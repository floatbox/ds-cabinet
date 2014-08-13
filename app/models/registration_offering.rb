require 'ds/pim/registration_prices'

class RegistrationOffering< PimOffering

  # Возвращает дату истечения продукта относительно даты from_date.
  #   Рассчитывается из даты from_date, периода и кол-ва периодов
  # @param[Time] from_date дата, от которой отсчитывается дата истечения,
  #   по умолчанию, Time.zone.now
  # @return[Time|nil] дата истечения
  #
  def expires from_date
    case price_unit
    when "Month"
      from_date + price_unit_qty.months
    else
      nil
    end
  end

  def self.reload_from_pim offering_id
    self.destroy_all
    rp = Ds::Pim::RegistrationPrices.new offering_id
    rp.prices.each do |price|
      attributes = price.to_h
      #{:offering_id=>"3000319", :price_id=>"3000329", :price_text=>"3 месяца", :price_unit=>"Month", :price_unit_qty=>3, :price_amount=>2400.0} 
      self.create(attributes)
    end
  end
end
