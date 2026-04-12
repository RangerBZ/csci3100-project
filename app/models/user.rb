class User < ApplicationRecord
  CUHK_LINK_EMAIL_REGEX = /\A[^@\s]+@link\.cuhk\.edu\.hk\z/i

  COLLEGE_LOCATIONS = [
    "Chung Chi College",
    "New Asia College",
    "United College",
    "Shaw College",
    "Morningside College",
    "S.H. Ho College",
    "CW Chu College",
    "Wu Yee Sun College",
    "Lee Woo Sing College"
  ].freeze

  LEGACY_LOCATION_MAPPINGS = {
    "chung chi" => "Chung Chi College",
    "chung chi college" => "Chung Chi College",
    "new asia" => "New Asia College",
    "new asia college" => "New Asia College",
    "united" => "United College",
    "united college" => "United College",
    "shaw" => "Shaw College",
    "shaw college" => "Shaw College",
    "morningside" => "Morningside College",
    "morningside college" => "Morningside College",
    "s.h. ho" => "S.H. Ho College",
    "s.h. ho college" => "S.H. Ho College",
    "cw chu" => "CW Chu College",
    "cw chu college" => "CW Chu College",
    "wu yee sun" => "Wu Yee Sun College",
    "wu yee sun college" => "Wu Yee Sun College",
    "lee woo sing" => "Lee Woo Sing College",
    "lee woo sing college" => "Lee Woo Sing College"
  }.freeze

  has_many :items, foreign_key: "seller_id"

  has_many :favorites, dependent: :destroy
  has_many :favorite_items, through: :favorites, source: :item

  has_secure_password

  before_validation :normalize_location

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: {
    with: CUHK_LINK_EMAIL_REGEX,
    message: "must end with @link.cuhk.edu.hk"
  }
  validates :password, presence: { on: :create }
  validates :password, length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: { on: :create }, if: :password_present?

  def self.find_seller_id(name)
    clean_name = name.to_s.strip
    user = find_by("name ILIKE ?", "%#{clean_name}%")
    user&.id
  end

  def generate_password_reset_code!
    self.password_reset_code = rand(100000..999999).to_s
    self.password_reset_expires_at = 1.hour.from_now # datetime()
    save!
  end

  def clear_password_reset_code!
    self.password_reset_code = nil
    self.password_reset_expires_at = nil
    save!
  end

  private

  def normalize_location
    cleaned_location = location.to_s.strip
    return if cleaned_location.blank?

    self.location = LEGACY_LOCATION_MAPPINGS[cleaned_location.downcase] || cleaned_location
  end

  def password_present?
    password.present?
  end
end
