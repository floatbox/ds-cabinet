require 'ds/cart/error'

module Ds
  module Cart

  class Api < Ds::Cart::Base

    def self.method_missing(method_name, *args)
      url = 'api/' + method_name.to_s.gsub('_', '/')
      request = {}
      args[0].each do |param, value|
        request[param.to_s.camelize] = value
      end
      response = Ds::Cart::Query.execute(url, request: request, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 500 then raise InternalError, JSON.parse(response[:body])["ErrorMessage"]
        else raise InternalError
      end
    end

    def self.get_cart_summary(user_id)
      url = 'api/items/summary'
      request = { userId: user_id}
      response = Ds::Cart::Query.execute(url, request: request, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 500 then raise InternalError, JSON.parse(response[:body])["ErrorMessage"]
        else raise InternalError
      end
    end

    def self.get_cart_items(user_id)
      url = 'api/items'
      request = { userId: user_id }
      response = Ds::Cart::Query.execute(url, request: request, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 500 then raise InternalError, JSON.parse(response[:body])["ErrorMessage"]
        else raise InternalError
      end
    end

    def self.get_cart_item(item_id)
      url = 'api/items'
      response = Ds::Cart::Query.execute(url, request: item_id, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 500 then raise InternalError, JSON.parse(response[:body])["ErrorMessage"]
        else raise InternalError
      end
    end

    def self.get_product(product_id)
      url = 'api/products'
      request = { id: product_id }
      response = Ds::Cart::Query.execute(url, request: product_id, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 500 then raise InternalError, JSON.parse(response[:body])["ErrorMessage"]
        else raise InternalError
      end
    end

    def self.get_products(offering_id)
      url = 'api/products'
      # request = { offeringId: offering_id }
      request = { userId: 'UAS100397' }
      response = Ds::Cart::Query.execute(url, request: request, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 500 then raise InternalError, JSON.parse(response[:body])["ErrorMessage"]
        else raise InternalError
      end
    end

    def self.get_order(order_id)
      url = 'api/orders'
      response = Ds::Cart::Query.execute(url, request: order_id, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 500 then raise InternalError, JSON.parse(response[:body])["ErrorMessage"]
        else raise InternalError
      end
    end

    def self.get_orders(user_id)
      url = 'api/orders'
      request =  { userId: user_id }
      response = Ds::Cart::Query.execute(url, request: request, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 500 then raise InternalError, JSON.parse(response[:body])["ErrorMessage"]
        else raise InternalError
      end
    end

    def self.add_to_cart(offering, article_url)
      url = 'api/products'
      request = {
          Offering: nil,
          SerializedOffering: offering.to_json,
          ArticleUrl: article_url,
          ArticleId: nil
        }
      response = Ds::Cart::Query.execute(url, request: request, method: :post)
      case response[:code]
        when 201 then JSON.parse(response[:body])
        when 500 then raise InternalError, JSON.parse(response[:body])["ErrorMessage"]
        else raise InternalError
      end
    end

    def self.cart_delete(id)
      url = 'api/items'
      request = {
          id: id
        }
      response = Ds::Cart::Query.execute(url, request: request, method: :delete)
      case response[:code]
        when 204 then true
        when 500 then raise InternalError, JSON.parse(response[:body])["ErrorMessage"]
        else raise InternalError, 'Unknown error'
      end
    end

    def self.add_order(options)
      url = 'api/orders'
      request = options.merge({
          Options: 3,
          ChoosePayer: true,
          Promocode: nil,
          PayerCompanyId: nil,
          SellerCompanyId:nil
        })
      response = Ds::Cart::Query.execute(url, request: request, method: :post)
      case response[:code]
        when 201 then JSON.parse(response[:body])
        when 500 then raise Error, JSON.parse(response[:body])["ErrorMessage"]
        else raise InternalError
      end
    end

  end

  end
end
