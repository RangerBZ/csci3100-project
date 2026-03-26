class User < ApplicationRecord
  has_many :items, foreign_key: "seller_id"

  def self.find_seller_id(name)
    find_by("name ILIKE ?", "%#{name}%").id
  end
end
