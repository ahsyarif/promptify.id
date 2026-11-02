require "test_helper"

class MidtransNotificationsControllerTest < ActionDispatch::IntegrationTest
  SERVER_KEY = "SB-Mid-server-test"

  setup do
    ENV["MIDTRANS_SERVER_KEY"] = SERVER_KEY
    @payment = payments(:pending)
  end

  teardown do
    ENV.delete("MIDTRANS_SERVER_KEY")
  end

  test "settlement activates membership" do
    notify(status: "settlement", code: "200")

    assert_response :success
    assert @payment.reload.paid?
    assert @payment.user.reload.member?
  end

  test "rejects a bad signature" do
    notify(status: "settlement", code: "200", signature: "bad")

    assert_response :forbidden
    assert @payment.reload.pending?
    assert_not @payment.user.reload.member?
  end

  test "rejects an amount that does not match the order" do
    notify(status: "settlement", code: "200", amount: "1000.00")

    assert_response :unprocessable_entity
    assert @payment.reload.pending?
    assert_not @payment.user.reload.member?
  end

  private
    def notify(status:, code:, amount: "49000.00", signature: nil)
      signature ||= Digest::SHA512.hexdigest("#{@payment.order_id}#{code}#{amount}#{SERVER_KEY}")
      post midtrans_notifications_url, params: {
        order_id: @payment.order_id,
        status_code: code,
        gross_amount: amount,
        transaction_status: status,
        signature_key: signature
      }, as: :json
    end
end
