require 'ds/purchase/offering_prices'

class RegistrationOffering< AccessPurchase
  after_initialize :init

  def self.reload_from_pim offering_id
    self.destroy_all
    rp = Ds::Purchase::OfferingPrices.new offering_id
    self.transaction do
      rp.prices.each do |price|
        attributes = price.to_h
        #{
        #  :offering_id=>"3000319", 
        #  :price_id=>"3000329", 
        #  :price_text=>"3 месяца", 
        #  :price_unit=>"Month", 
        #  :price_unit_qty=>3, 
        #  :price_amount=>2400.0
        #}
        
        self.create(attributes)
      end
    end
  end

  def self.as_hash # to use in controllers, views and partials
    self.order('amount ASC').load.
      map{ |e| { 
                 offering_price_id: e.offering_price_id, 
                 text:   e.text, 
                 amount: e.amount,
                 code:   e.code
               }
         }
  end
end
