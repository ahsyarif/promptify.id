# Receives Midtrans HTTP notifications. Inherits from ActionController::Base so the
# Authentication concern and the allow_browser check never redirect the webhook.
class MidtransNotificationsController < ActionController::Base
  skip_forgery_protection

  def create
    return head :forbidden unless Midtrans.valid_signature?(params)

    payment = Payment.find_by(order_id: params[:order_id])
    return head :not_found unless payment
    return head :unprocessable_entity unless params[:gross_amount].to_d == payment.amount

    payment.apply_status!(params[:transaction_status])
    head :ok
  end
end
