class PaymentsController < ApplicationController
  rate_limit to: 5, within: 10.minutes, only: :create,
             with: -> { redirect_to membership_path, alert: "Too many attempts. Try again in a few minutes." }

  def create
    return redirect_to(root_path, notice: "You're already a member.") if Current.user.member?

    payment = Current.user.payments.create!(order_id: "promptify-#{Current.user.id}-#{SecureRandom.hex(6)}", amount: Payment::PRICE)
    charge = Midtrans.charge_qris(order_id: payment.order_id, amount: payment.amount, email: Current.user.email_address)
    urls = Array(charge["actions"]).to_h { |a| [ a["name"], a["url"] ] }
    payment.update!(qr_url: urls["generate-qr-code"] || urls["generate-qr-code-v2"], midtrans_transaction_id: charge["transaction_id"])
    redirect_to payment
  rescue Midtrans::Error => e
    Rails.logger.error("Midtrans charge failed for #{payment&.order_id}: #{e.message}")
    payment&.update(status: "failure")
    redirect_to membership_path, alert: "Couldn't start the QRIS payment. Please try again."
  end

  def show
    @payment = Current.user.payments.find_by!(order_id: params[:id])
    refresh_from_midtrans if @payment.pending?

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Payment received — all prompts unlocked!" if @payment.paid? }
      format.json { render json: { status: @payment.status, paid: @payment.paid? } }
    end
  end

  private
    # Polling fallback: webhooks can't reach localhost and may arrive late.
    def refresh_from_midtrans
      @payment.apply_status!(Midtrans.status(@payment.order_id)["transaction_status"])
    rescue Midtrans::Error => e
      Rails.logger.warn("Midtrans status check failed for #{@payment.order_id}: #{e.message}")
    end
end
