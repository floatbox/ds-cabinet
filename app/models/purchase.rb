require 'ds/purchase/order'

class Purchase< PimOffering
  belongs_to :user
  has_one :order, as: :orderable
  delegate :update_status, :post, :effective_amount, to: :order

  def self.not_paid offering_id= '*', offering_price_id= '*'
    Purchase.joins(:order).where(
      'orders.payment_date'             => nil, 
      'pim_offerings.offering_id'       => offering_id,
      'pim_offerings.offering_price_id' => offering_price_id)
  end

  def paid?
    order && order.paid?
  end

  def post success_url, error_url
    create_order
    order.post success_url, error_url
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
    case unit
    when "Month"
      from_date + unit_qty.months
    else
      nil
    end
  end
end

