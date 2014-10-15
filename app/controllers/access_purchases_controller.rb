class AccessPurchasesController < ApplicationController

  before_action :authenticate, except: (Rails.env.development? ? [:processed, :index] : [:processed])

  def index
  end

  def create
    if params[:code].nil? || (ro = RegistrationOffering.find_by_code params[:code]).nil?
      render json: { base: ['Продукт не найден'] }, status: :unprocessable_entity
    else
      @current_user.access_purchases.not_paid.destroy_all
      ap_attributes = ro.attributes_hash.merge(promocode: params[:promocode])
      ap = @current_user.access_purchases.create(ap_attributes)
      ap.post(access_purchase_processed_url(ap.id), 
              access_purchase_processed_url(ap.id))

      effective_amount = ap.effective_amount # gets effective order amount from cart
      if !params[:promocode].empty? && ap.amount == ap.effective_amount
        # Промокод указан, но цена заказа в корзине равна базовой цене тарифного плана
        ap.errors.add(:promocode, :wrong_value)
        render json: ap.errors, status: :unprocessable_entity, content_type: 'application/json' #FIXME somehow doesn't work without content_type
      else
        render json: { 
            payment: { 
              amount: effective_amount,
              link: ap.order.url, 
              offering_price_id: ap.offering_price_id
            }
          }, :content_type => 'application/json' #FIXME somehow doesn't work without content_type
      end
    end
  end

  def processed
    ap = AccessPurchase.find params[:access_purchase_id]
    ap.update_status unless ap.paid?
    if ap.paid?
      r = ap.user.registration
      r.confirm_payment! if r && r.workflow_state == "awaiting_payment"
      redirect_to root_url
    else
      @error_message = "Платеж не выполнен" 
      render action: :index
    end
  end
end
