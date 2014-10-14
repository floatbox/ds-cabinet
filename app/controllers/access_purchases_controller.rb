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

      render json: { payment: { process_payment_link: ap.order.url, process_payment_desc: ap.text }}, :content_type => 'application/json'
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
