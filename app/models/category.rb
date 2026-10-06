class Category < ApplicationRecord
  has_many :prompts, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: true,
                   format: { with: /\A[a-z0-9-]+\z/ }

  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  scope :ordered, -> { order(:position, :name) }

  def to_param = slug

  private
    def generate_slug
      self.slug = name.parameterize
    end
end
