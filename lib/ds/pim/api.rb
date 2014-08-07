module Ds
  module Pim

  class Api < Ds::Pim::Base

    def self.method_missing(method_name, *args)
      url = method_name.to_s.camelize(:lower)
      request = {}
      args[0].each do |param, value|
        request[param.to_s.camelize(:lower)] = value
      end
      response = Ds::Pim::Query.execute(url, request: request, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 400 then raise InvalidCredentials
        else raise InternalError
      end
    end

    def self.get_product_offering(offering_id)
      # self.class.get("#{PIM_SERVER}productOffering/" + id).body
      url = 'productOffering/' + offering_id
      response = Ds::Pim::Query.execute(url)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 400 then raise InvalidCredentials
        else raise InternalError
      end
    end

    def self.get_product_offering_prices(offering_id)
      url = 'productOffering/' + offering_id + '/offeringPrices'
      response = Ds::Pim::Query.execute(url)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 400 then raise InvalidCredentials
        else raise InternalError
      end
    end

    def self.get_product_offering_price(offering_id, price_id)
      url = 'productOffering/' + offering_id + '/offeringPrices/' + price_id
      response = Ds::Pim::Query.execute(url)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 400 then raise InvalidCredentials
        else raise InternalError
      end
    end

  end

  end
end
