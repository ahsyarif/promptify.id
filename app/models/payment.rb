class Payment < ApplicationRecord
  PRICE = 49_000 # IDR, lifetime membership
  PAID_STATUSES = %w[settlement capture].freeze

  belongs_to :user

  validates :order_id, presence: true, uniqueness: true
  validates :amount, numericality: { greater_than: 0 }

  def to_param = order_id
  def paid? = status.in?(PAID_STATUSES)
  def pending? = status == "pending"

  # Idempotent; a paid payment is never downgraded by a late/out-of-order status.
  def apply_status!(new_status)
    return if paid?

    transaction do
      update!(status: new_status, paid_at: (Time.current if new_status.in?(PAID_STATUSES)))
      user.update!(member_since: Time.current) if paid? && !user.member?
    end
  end
end
