class Prompt < ApplicationRecord
  SORTS = {
    "newest"  => { created_at: :desc },
    "popular" => { bookmarks_count: :desc, created_at: :desc },
    "title"   => { title: :asc }
  }.freeze

  belongs_to :category
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarkers, through: :bookmarks, source: :user

  has_one_attached :image

  validates :title, presence: true, length: { maximum: 120 }
  validates :body, presence: true
  validates :slug, presence: true, uniqueness: true,
                   format: { with: /\A[a-z0-9-]+\z/ }

  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  scope :with_image, -> { with_attached_image }
  scope :in_category, ->(category) { category ? where(category: category) : all }
  scope :sorted_by, ->(key) { order(SORTS.fetch(key.to_s, SORTS["newest"])) }

  # Case-insensitive search across title, prompt text, negative prompt,
  # model name and category name. Every whitespace-separated term must match
  # somewhere (AND semantics), so "neon portrait" narrows results.
  scope :search, ->(query) {
    terms = query.to_s.downcase.split.first(8)
    next all if terms.empty?

    relation = left_joins(:category)
    terms.reduce(relation) do |rel, term|
      pattern = "%#{sanitize_sql_like(term)}%"
      rel.where(
        "LOWER(prompts.title) LIKE :q OR LOWER(prompts.body) LIKE :q OR " \
        "LOWER(COALESCE(prompts.negative_prompt, '')) LIKE :q OR " \
        "LOWER(COALESCE(prompts.ai_model, '')) LIKE :q OR LOWER(categories.name) LIKE :q",
        q: pattern
      )
    end
  }

  def to_param = slug

  def related(limit: 3)
    category.prompts.where.not(id: id).with_image.sorted_by("popular").limit(limit)
  end

  private
    def generate_slug
      base = title.parameterize
      candidate = base
      n = 2
      while Prompt.where.not(id: id).exists?(slug: candidate)
        candidate = "#{base}-#{n}"
        n += 1
      end
      self.slug = candidate
    end
end
