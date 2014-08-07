module Ds
  module Cart

    class Base

      def self.order_statuses
        {
          0  => 'OrderCreated', # (0) – заказ создан;
          1  => 'OrderAssociated', #(1) – пользователь выбрал от чьего лица будет производить оплату ;
          2  => 'PaymentInProgress', #(2) – пользователь в процессе оплаты заказа;
          3  => 'PaymentSucess', #(3) – успешная оплата заказа;
          4  => 'PaymentError', #(4) – ошибка во время оплаты заказа;
          5  => 'PaymentBillCreated', #(5) – выбран отложенный способ оплаты;
          6  => 'OrderCanceled', #(6) – заказ отменен;
          7  => 'OrderCompleted', #(7) – сделка завершена;
          8  => 'OrderPartiallyPaid', #(8) – заказ частично оплачен;
          20 => 'ItemsDeletedFromCart', #(20) [служебный статус] – используется только при отправке уведомления об удалении товаров из Корзины.
         }
      end


    end

  end
end
