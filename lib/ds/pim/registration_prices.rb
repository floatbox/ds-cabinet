require 'ds/pim'

module Ds
  module Pim
    class InvalidPrice< RuntimeError; end

    class Price
      OPTIONS = [
        :offering_id,
        :price_id,
        :price_text,     
        :price_unit,     # пока одно значение - "Month"
        :price_unit_qty, # кол-во периодов, например, 3
        :price_amount    # стоимость в рублях за кол-во периодов
      ]

      attr_reader *OPTIONS 
      
      def initialize options
        OPTIONS.each do |key|
          var = "@#{key}".intern
          instance_variable_set var, options[key]
        end
      end

      def [] key
        method = key.intern
        self.respond_to?(method) ? self.send(method) : nil
      end

      def to_h attributes_arr = OPTIONS
        {}.tap{ |hash| attributes_arr.each{|e| hash[e] = self[e] }}
      end

      # Проверяет, все ли атрибуты имеют не пустое значение
      # @return[Boolean] результат проверки
      #
      def valid?
        @errors = []
        OPTIONS.each do |key|
          var = "@#{key}".intern
          value = instance_variable_get var
          @errors<< "instance variable #{var} should not be nil" if value.nil?
        end
        @errors.empty? ? true : false
      end

      def error_msg
        @errors.join("\n")
      end
    end

    class RegistrationPrices
      attr_reader :offering_id, :raw_prices

      # @param[String] offering_id - product id in Pim subsystem, e.g. '5336743' 
      #
      def initialize offering_id
        @offering_id = offering_id.to_s
      end

      # Возвращает массив объектов типа Ds::Pim::Price
      # @return[Ds::Pim::Price] цены на продукты, используемые при регистрации
      #
      def prices
        unless (@prices && @prices.empty?)
          @prices = []
          @raw_prices ||= self.request_raw_prices
          @parsed_prices ||= self.parse_raw_prices @offering_id, @raw_prices
          @parsed_prices.each do |price_hash|
            price = Price.new price_hash
            raise InvalidPrice, price.error_msg unless price.valid?
            @prices<< price
          end
        end
        @prices
        #[#<Ds::Pim::Price:0x0000000889b8d8 @id=3000346, @price_id=3000343, @price_text="1 месяц", @price_unit="Month", @price_unit_qty=1, @price_amount=10.0, @errors=[]>, 
        # #<Ds::Pim::Price:0x0000000889b4c8 @id=3000342, @price_id=3000336, @price_text="12 месяцев", @price_unit="Month", @price_unit_qty=12, @price_amount=7200.0, @errors=[]>, 
        # #<Ds::Pim::Price:0x0000000889b0b8 @id=3000333, @price_id=3000329, @price_text="3 месяца", @price_unit="Month", @price_unit_qty=3, @price_amount=2400.0, @errors=[]>]
      end

      # Gets raw prices for offering id
      def request_raw_prices
        Api.get_product_offering_prices @offering_id # Array
      end

      # Parses prices info, returns distilled price information
      # @param[prices|nil] raw prices info from pim system
      # @return[Array] an array of hashes, each like {:id=>5336757, :text=>"3 месяца",   :price=>2400.0}
      # [{:id=>5336757, :text=>"3 месяца",   :price=>2400.0}, 
      #  {:id=>5336766, :text=>"12 месяцев", :price=>7200.0}, 
      #  {:id=>5337634, :text=>"1 месяц",    :price=>10.0}]
      #
      def parse_raw_prices offering_id, prices=nil
        prices ||= @raw_prices
        result = []
        prices.each do |price|
          # > price.keys
          # => ["Id", "BillingPeriod", "ChargeClasses", "CreateDate", "Name", 
          #     "OfferingId", "PriceRules", "Status", "UpdateDate"]
          price_id = price["Id"].to_s
          
          ids_texts = price["ChargeClasses"].map do |e| 
            period = e["Period"] || {}
            {
              id:              e["Id"], 
              offering_id:     offering_id,
              price_text:      period["Name"],
              price_unit:      period["UnitOfMeasure"],
              price_unit_qty:  period["Value"],
              price_id:        price_id
            }
          end
          
          ids_amounts = price["PriceRules"].map{|e| e["ChargePrices"]}.flatten.select{|e| \
            e["Price"]>0.0}.map{|e| {id: e["ChargeClassId"], price_amount: e["Price"]}}
          # [{:id=>5336757, :amount=>2400.0}]
          
          # set amount in ids_texts
          ids_amounts.each do |id_amount|
            # {:id=>5336757, :price=>2400.0}
            id     = id_amount[:id]
            amount = id_amount[:price_amount]
            ids_texts.each{|id_text| id_text[:price_amount] = amount if id_text[:id] == id}
          end
          result << ids_texts.select{|e| e.has_key? :price_amount }
        end

        result.flatten.map{|e| e.delete(:id); e}
      end
    end
  end
end

if __FILE__ == $0
  require 'ds/pim/registration_prices.rb'
  rp = Ds::Pim::RegistrationPrices.new '3000319'
  pp rp.prices
  #pp rp.raw_prices
end
