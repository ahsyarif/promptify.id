class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :prompt, counter_cache: true

  validates :prompt_id, uniqueness: { scope: :user_id }
end
