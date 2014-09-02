class AccessPurchasesController < ApplicationController

  before_action :authenticate, except: [:processed, :index]

  def index
  end

  def create
    if params[:code].nil? || (ro = RegistrationOffering.find_by_code params[:code]).nil?
      render json: { base: ['Продукт не найден'] }, status: :unprocessable_entity
    else
      @current_user.access_purchases.not_paid.destroy_all
      ap = @current_user.access_purchases.create(ro.attributes_hash)
      ap.post(access_purchase_processed_url(ap.id), 
              access_purchase_processed_url(ap.id))

      render json: { process_payment_link: ap.order.url, process_payment_desc: ap.text }
    end
  end

  def processed
    ap = AccessPurchase.find params[:access_purchase_id]
    ap.update_status unless ap.paid?
    if ap.paid?
      redirect_to root_url
    else
      @error_message = "Платеж не выполнен" 
      render action: :index
    end
  end
end
