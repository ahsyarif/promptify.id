class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_prompts, through: :bookmarks, source: :prompt
  has_many :payments, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true,
                            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, allow_nil: true

  def member? = member_since.present?

  def bookmarked?(prompt)
    bookmarked_prompt_ids.include?(prompt.id)
  end

  # Memoized so rendering a grid of cards costs a single query.
  def bookmarked_prompt_ids
    @bookmarked_prompt_ids ||= bookmarks.pluck(:prompt_id).to_set
  end
end
