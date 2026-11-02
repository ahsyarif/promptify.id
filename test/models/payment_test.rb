require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  test "a paid payment is never downgraded by a later status" do
    payment = payments(:pending)
    user = payment.user

    payment.apply_status!("settlement")
    assert payment.reload.paid?
    assert user.reload.member?

    payment.apply_status!("expire")
    assert_equal "settlement", payment.reload.status
  end
end
