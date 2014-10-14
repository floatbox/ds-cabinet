require 'ds/cart'
require 'simple_serializer'

# Простой интерфейс для создания заказа на закупку в системе Cart
# Чтобы создать заказ, на каждый товар надо иметь массив информации по товару: 
#   offering[0] код товара offering_id 
#   offering[1] код ценового предложения offering_price_id
#   offering[2] url страницы товара (может быть не существующим или фейковым)
# Чтобы создать заказ на несколько товаров надо иметь массив из наборов
#   информации по всем товарам [offering1, offering2, ... offeringN]
# Если заказ создан успешно, то Order#post возвращает хеш с информацией по заказу:
#   "OrderId"   - числовой код заказа, 
#   "TargetUrl" - ссылка, при переходе на которую по методу post, открывается форма
#     для выбора способа платежа
# Raises:
#   Curl::Err::ConnectionFailedError
module Ds
  module Purchase
    class Order

      PAID=3
      
      extend SimpleSerializer

      attr_reader :order_id, :url, :status, :last_edited_time

      def self.statuses
        Ds::Cart::Base.order_statuses
      end

      def paid?
        @status == PAID
      end

      # @param[String] client_integration_id - A string id of user in UAS, like 'UAS100452'
      # @param[Array] offerings_arr - an array of arrays like
      #   [[offering1_id, offering1_price_id, offering1_url],...,[offeringN_id, offeringN_price_id, offeringN_url]]
      # @param[String] success_url, An url to which brawser to be redirected after successful payment
      # @param[String] error_url, An url to which brawser to be redirected after unsuccessful payment
      # 
      def post(client_integration_id, offerings_arr, success_url, error_url, promocode=nil)
        @client_integration_id = client_integration_id
        @order_options = order_options(offerings_arr, success_url, error_url, promocode)
        if @order_id.nil? 
          Ds::Cart::Api.add_order(@order_options).tap do |add_order_result|
            # {"OrderId"=>20026, 
            #  "TargetUrl"=>"http://payment-delo.sredda.ru:8081/
            #                Payment/Credentials?PaymentID=df50a9e4-846f-4019-9fd6-8b2efb17f705"}
            @order_id  = add_order_result["OrderId"]
            @url       = add_order_result["TargetUrl"]
          end
        end
      end

      def update_status
        order_info = Ds::Cart::Api.get_order(@order_id)
        #{
        #  "OrderId"=>20026, 
        #  "CreatedDate"=>"2014-08-12T16:47:13.527", 
        #  "OrderStatus"=>2, 
        #  "LastEditedDate"=>"2014-08-12T16:47:18.86", 
        #  "Amount"=>7200.0, 
        #  "CompanyId"=>nil, 
        #  "UserId"=>"UAS100452"
        #}

        @last_edited_time = order_info["LastEditedDate"]
        @status = order_info["OrderStatus"]
      end

      # Returns effective order amount
      # @return [Float] order amount with promocode applied
      def get_amount
        binding.pry
        order_info = Ds::Cart::Api.get_order(@order_id)
        #{
        #  "OrderId"=>20026, 
        #  "CreatedDate"=>"2014-08-12T16:47:13.527", 
        #  "OrderStatus"=>2, 
        #  "LastEditedDate"=>"2014-08-12T16:47:18.86", 
        #  "Amount"=>7200.0, 
        #  "CompanyId"=>nil, 
        #  "UserId"=>"UAS100452"
        #}
        order_info["Amount"]
      end

      protected

      # Builds and returns order hash, suitable to pass to external api
      # @param[Array] offerings_arr - an array of arrays like
      #   [[offering1_id, offering1_price_id, offering1_url],...,[offeringN_id, offeringN_price_id, offeringN_url]]
      # @return[Hash]
      #
      def order_options(offerings_arr, success_url, error_url, promocode)
        {
          UserId:     @client_integration_id,
          SuccessUrl: success_url,
          ErrorUrl:   error_url,
          Promocode:  promocode,
          Offerings:  offerings_arr.map{|o| self.order_line_options(*o)}
        }
      end

      # Returns order line hash, is being used to build order hash, see [Ds::Purchase::Order#order_options]
      # @param[String] offering_id       - product id from Pim
      # @param[String] offering_price_id - product price id
      # @param[String] offering_url      - product url
      #
      def order_line_options offering_id, offering_price_id, offering_url
        {
          Offering: {
            OfferingId:       offering_id,
            OfferingPriceId:  offering_price_id,
            ClientKey:        @client_integration_id,
            Characteristics:  [],
          },
          ArticleUrl:         offering_url,
          ArticleId:          nil,
          SerializedOffering: nil,
          ProductsForUpdate:  nil,
          MerchantId:         nil
        }
      end
    end
  end
end

if __FILE__ == $0
  po = Ds::Purchase::Order.new
  puts po.post('UAS100452',
               [['3000319', '3000329', 'http://market.yandex.ru/model-spec.xml?modelid=10890865&hid=6427100']],
               'http://somewhere.com/success/',
               'http://somewhere.com/error/')
  po.status
  po.update_status
  s= Ds::Purchase::Order.dump po
  poo= po.class.load s
end
