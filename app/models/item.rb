class Item < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :favorited_items, through: :favorites, source: :user

  belongs_to :seller, class_name: "User", foreign_key: "seller_id"
  belongs_to :reserver, class_name: "User", foreign_key: "reserver_id", optional: true

  has_one_attached :photo

  validates :name, presence: true
  validates :description, presence: true
  validates :category, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  SEARCH_SORT_OPTIONS = {
    "relevance" => "relevance",
    "newest" => "newest",
    "oldest" => "oldest",
    "price_low_to_high" => "price_low_to_high",
    "price_high_to_low" => "price_high_to_low"
  }.freeze

  scope :with_keyword, ->(keyword) do
    next all if keyword.blank?

    stripped_keyword = keyword.strip
    quoted_query = connection.quote(stripped_keyword)
    quoted_contains = connection.quote("%#{sanitize_sql_like(stripped_keyword)}%")
    threshold = 0.18

    search_rank_sql = <<~SQL.squish
      GREATEST(
        similarity(items.name, #{quoted_query}),
        similarity(COALESCE(items.description, ''), #{quoted_query}),
        similarity(COALESCE(items.category, ''), #{quoted_query}),
        similarity(COALESCE(items.status, ''), #{quoted_query}),
        similarity(COALESCE(users.name, ''), #{quoted_query}),
        similarity(COALESCE(users.location, ''), #{quoted_query}),
        word_similarity(items.name, #{quoted_query}),
        word_similarity(COALESCE(items.description, ''), #{quoted_query})
      )
    SQL

    matching_sql = <<~SQL.squish
      items.name ILIKE #{quoted_contains}
      OR items.description ILIKE #{quoted_contains}
      OR items.category ILIKE #{quoted_contains}
      OR items.status ILIKE #{quoted_contains}
      OR users.name ILIKE #{quoted_contains}
      OR users.location ILIKE #{quoted_contains}
      OR similarity(items.name, #{quoted_query}) >= #{threshold}
      OR similarity(COALESCE(items.description, ''), #{quoted_query}) >= #{threshold}
      OR similarity(COALESCE(items.category, ''), #{quoted_query}) >= #{threshold}
      OR similarity(COALESCE(items.status, ''), #{quoted_query}) >= #{threshold}
      OR similarity(COALESCE(users.name, ''), #{quoted_query}) >= #{threshold}
      OR similarity(COALESCE(users.location, ''), #{quoted_query}) >= #{threshold}
      OR word_similarity(items.name, #{quoted_query}) >= #{threshold}
      OR word_similarity(COALESCE(items.description, ''), #{quoted_query}) >= #{threshold}
    SQL

    joins(:seller)
      .select(Arel.sql("items.*, #{search_rank_sql} AS search_rank"))
      .where(Arel.sql(matching_sql))
  end

  scope :with_category, ->(category) do
    next all if category.blank?

    where("LOWER(items.category) = ?", category.strip.downcase)
  end

  scope :with_status, ->(status) do
    next all if status.blank?

    where("LOWER(items.status) = ?", status.strip.downcase)
  end

  scope :with_seller_location, ->(location) do
    next all if location.blank?

    joins(:seller).where("LOWER(users.location) = ?", location.strip.downcase)
  end

  scope :min_price, ->(price) do
    next all if price.blank?

    where("items.price >= ?", price.to_i)
  end

  scope :max_price, ->(price) do
    next all if price.blank?

    where("items.price <= ?", price.to_i)
  end

  scope :posted_within_days, ->(days) do
    next all if days.blank?

    normalized_days = days.to_i
    next all if normalized_days <= 0

    where("CAST(items.post_date AS date) >= ?", normalized_days.days.ago.to_date)
  end

  def self.search(params)
    filters = params.to_h.symbolize_keys
    requested_sort = filters[:sort].presence || (filters[:keyword].present? ? "relevance" : "newest")
    requested_sort = "newest" if requested_sort == "relevance" && filters[:keyword].blank?

    results = with_keyword(filters[:keyword])
      .with_category(filters[:category])
      .with_status(filters[:status])
      .with_seller_location(filters[:seller_location])
      .min_price(filters[:min_price])
      .max_price(filters[:max_price])
      .posted_within_days(filters[:posted_within_days])

    sort(results, requested_sort)
  end

  def self.autocomplete(keyword, limit: 8)
    return [] if keyword.blank?

    stripped_keyword = keyword.strip
    prefix_keyword = "#{sanitize_sql_like(stripped_keyword)}%"
    contains_keyword = "%#{sanitize_sql_like(stripped_keyword)}%"
    matching_sql = sanitize_sql_array([
      "items.name ILIKE :prefix OR items.name ILIKE :contains OR similarity(items.name, :query) >= :threshold",
      prefix: prefix_keyword,
      contains: contains_keyword,
      query: stripped_keyword,
      threshold: 0.3
    ])
    priority_sql = sanitize_sql_array([
      <<~SQL.squish,
        CASE
          WHEN items.name ILIKE :prefix THEN 3
          WHEN items.name ILIKE :contains THEN 2
          ELSE 1
        END
      SQL
      prefix: prefix_keyword,
      contains: contains_keyword
    ])
    rank_sql = sanitize_sql_array([
      "similarity(items.name, :query)",
      query: stripped_keyword
    ])

    where(Arel.sql(matching_sql))
      .where.not(name: [ nil, "" ])
      .select(
        "items.name",
        Arel.sql("MAX(#{priority_sql}) AS autocomplete_priority"),
        Arel.sql("MAX(#{rank_sql}) AS autocomplete_rank")
      )
      .group(:name)
      .order(Arel.sql("autocomplete_priority DESC, autocomplete_rank DESC, items.name ASC"))
      .limit(limit)
      .map(&:name)
  end

  def self.available_seller_locations
    User::COLLEGE_LOCATIONS
  end

  def self.sort(relation, sort)
    case SEARCH_SORT_OPTIONS[sort]
    when "oldest"
      relation.order(Arel.sql("CAST(items.post_date AS date) ASC, items.created_at ASC"))
    when "price_low_to_high"
      relation.order(price: :asc, created_at: :desc)
    when "price_high_to_low"
      relation.order(price: :desc, created_at: :desc)
    when "relevance"
      relation.order(Arel.sql("search_rank DESC NULLS LAST, CAST(items.post_date AS date) DESC, items.created_at DESC"))
    else
      relation.order(Arel.sql("CAST(items.post_date AS date) DESC, items.created_at DESC"))
    end
  end
end
