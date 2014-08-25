require 'ds/purchase/order'

class Purchase< PimOffering
  belongs_to :user
  has_one :order, as: :orderable

  def paid?
    order && order.paid?
  end

  # Checks if access is not expired by given date
  # @param[Time] to_date - given date to check expiration against
  # @return[Boolean] true if not expired, otherwise false
  #
  def expired? to_date = Time.now
    order && (
      expiration_date = self.expires(order.payment_date || Time.now)
      !(expiration_date && expiration_date > to_date)
    )
  end

  def paid_and_not_expired? to_date = Time.now
    self.paid? && !self.expired?(to_date)
  end

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

  def create_order 
    @po = Ds::Purchase::Order.new(user.integration_id) # 'UAS100452'
  end

  def post
    opts = po.order_options([
      offering_id, 
      offering_price_id, 
      'http://market.yandex.ru/model-spec.xml?modelid=10890865&hid=6427100'
    ])
    @po.add_order opts    
  end
end

