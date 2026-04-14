# This whole file was originally AI generated (before Apr. 14th 16:53). 
# This file is now fully reviewed and modified by hand
require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:seller) { User.create!(name: "seller_user", email: "seller@link.cuhk.edu.hk", password: "password", password_confirmation: "password", location: "Chung Chi College") }
  let(:reserver) { User.create!(name: "reserver_user", email: "reserver@link.cuhk.edu.hk", password: "password", password_confirmation: "password", location: "New Asia College") }

  let(:valid_attributes) do
    {
      name: "Test Lamp",
      description: "A beautiful lamp",
      category: "furniture",
      price: 29.99,
      seller: seller,
      post_date: Date.current,
      status: "available"
    }
  end

  describe "validations" do
    it "is valid with valid attributes" do
      item = Item.new(valid_attributes)
      expect(item).to be_valid
    end

    it "is invalid without a name" do
      item = Item.new(valid_attributes.merge(name: nil))
      expect(item).not_to be_valid
      expect(item.errors[:name]).to include("can't be blank")
    end

    it "is invalid without a description" do
      item = Item.new(valid_attributes.merge(description: nil))
      expect(item).not_to be_valid
      expect(item.errors[:description]).to include("can't be blank")
    end

    it "is invalid without a category" do
      item = Item.new(valid_attributes.merge(category: nil))
      expect(item).not_to be_valid
      expect(item.errors[:category]).to include("can't be blank")
    end

    it "is invalid without a price" do
      item = Item.new(valid_attributes.merge(price: nil))
      expect(item).not_to be_valid
      expect(item.errors[:price]).to include("can't be blank")
    end

    it "is invalid with a price less than or equal to 0" do
      item = Item.new(valid_attributes.merge(price: 0))
      expect(item).not_to be_valid
      expect(item.errors[:price]).to include("must be greater than 0")
    end

    it "is valid with a positive price" do
      item = Item.new(valid_attributes.merge(price: 10.50))
      expect(item).to be_valid
    end
  end

  describe "scopes" do
    let!(:item1) { Item.create!(valid_attributes.merge(name: "Lamp", description: "Nice lamp", category: "furniture", price: 50, post_date: 5.days.ago)) }
    let!(:item2) { Item.create!(valid_attributes.merge(name: "Desk", description: "Wooden desk", category: "furniture", price: 150, post_date: 2.days.ago)) }
    let!(:item3) { Item.create!(valid_attributes.merge(name: "Book", description: "Ruby Book", category: "books", price: 25, post_date: 1.day.ago)) }

    describe ".with_keyword" do
      it "returns all items when keyword is blank" do
        expect(Item.with_keyword("")).to match_array([item1, item2, item3])
      end

      it "returns items matching by name" do
        expect(Item.with_keyword("Lamp")).to include(item1)
        expect(Item.with_keyword("Lamp")).not_to include(item2, item3)
      end

      it "returns items matching by description" do
        expect(Item.with_keyword("Wooden")).to include(item2)
      end

      it "returns items matching by category" do
        expect(Item.with_keyword("books")).to include(item3)
      end

      it "returns items matching by status" do
        item1.update(status: "available")
        expect(Item.with_keyword("available")).to include(item1)
      end

      it "returns items matching by seller name" do
        expect(Item.with_keyword(seller.name)).to include(item1, item2, item3)
      end

      it "returns items matching by seller location" do
        expect(Item.with_keyword(seller.location)).to include(item1, item2, item3)
      end
    end

    describe ".with_category" do
      it "returns all items when category is blank" do
        expect(Item.with_category("")).to match_array([item1, item2, item3])
      end

      it "filters by category case-insensitively" do
        expect(Item.with_category("FURNITURE")).to match_array([item1, item2])
        expect(Item.with_category("books")).to match_array([item3])
      end
    end

    describe ".with_status" do
      before do
        item1.update(status: "available")
        item2.update(status: "sold")
        item3.update(status: "reserved")
      end

      it "returns all items when status is blank" do
        expect(Item.with_status("")).to match_array([item1, item2, item3])
      end

      it "filters by status case-insensitively" do
        expect(Item.with_status("AVAILABLE")).to match_array([item1])
        expect(Item.with_status("sold")).to match_array([item2])
        expect(Item.with_status("reserved")).to match_array([item3])
      end
    end

    describe ".with_seller_location" do
      let(:location_user) { User.create!(name: "location_user", email: "loc@link.cuhk.edu.hk", password: "password", password_confirmation: "password", location: "United College") }
      let!(:item_with_location) { Item.create!(valid_attributes.merge(seller: location_user, name: "Location Item")) }

      it "returns all items when location is blank" do
        expect(Item.with_seller_location("")).to include(item1, item2, item3, item_with_location)
      end

      it "filters by seller location case-insensitively" do
        expect(Item.with_seller_location("UNITED COLLEGE")).to include(item_with_location)
        expect(Item.with_seller_location("United College")).to include(item_with_location)
        expect(Item.with_seller_location("Chung Chi College")).not_to include(item_with_location)
      end
    end

    describe ".min_price" do
      it "returns items with price >= given price" do
        expect(Item.min_price(50)).to include(item1, item2)
        expect(Item.min_price(50)).not_to include(item3)
      end

      it "returns all items when price is blank" do
        expect(Item.min_price("")).to match_array([item1, item2, item3])
      end
    end

    describe ".max_price" do
      it "returns items with price <= given price" do
        expect(Item.max_price(50)).to include(item1, item3)
        expect(Item.max_price(50)).not_to include(item2)
      end

      it "returns all items when price is blank" do
        expect(Item.max_price("")).to match_array([item1, item2, item3])
      end
    end

    describe ".posted_within_days" do
      it "returns items posted within given days" do
        expect(Item.posted_within_days(3)).to include(item2, item3)
        expect(Item.posted_within_days(3)).not_to include(item1)
      end

      it "returns all items when days is blank or <= 0" do
        expect(Item.posted_within_days("")).to match_array([item1, item2, item3])
        expect(Item.posted_within_days(0)).to match_array([item1, item2, item3])
      end
    end
  end

  describe ".search" do
    let!(:item1) { Item.create!(valid_attributes.merge(name: "Lamp", price: 50, category: "furniture", post_date: 5.days.ago)) }
    let!(:item2) { Item.create!(valid_attributes.merge(name: "Desk", price: 150, category: "furniture", post_date: 2.days.ago)) }
    let!(:item3) { Item.create!(valid_attributes.merge(name: "Book", price: 25, category: "books", post_date: 1.day.ago)) }

    it "filters by category" do
      results = Item.search({ keyword: "", category: "books" })
      expect(results).to include(item3)
      expect(results).not_to include(item1, item2)
    end

    it "filters by status" do
      item2.update(status: "sold")
      results = Item.search({ status: "sold" })
      expect(results).to include(item2)
      expect(results).not_to include(item1, item3)
    end

    it "filters by seller location" do
      location_user = User.create!(name: "loc_seller", email: "loc@link.cuhk.edu.hk", password: "password", password_confirmation: "password", location: "Shaw College")
      item_with_loc = Item.create!(valid_attributes.merge(seller: location_user, name: "Location Item"))
      results = Item.search({ seller_location: "Shaw College" })
      expect(results).to include(item_with_loc)
    end

    it "filters by min and max price" do
      results = Item.search({ min_price: 30, max_price: 100 })
      expect(results).to include(item1)
      expect(results).not_to include(item2, item3)
    end

    it "filters by posted within days" do
      results = Item.search({ posted_within_days: 3 })
      expect(results).to include(item2, item3)
      expect(results).not_to include(item1)
    end

    it "sorts by newest when no keyword and sort is relevance" do
      results = Item.search({ sort: "relevance" })
      expect(results.first).to eq(item3)
      expect(results.last).to eq(item1)
    end

    it "sorts by price low to high" do
      results = Item.search({ sort: "price_low_to_high" })
      expect(results).to eq([item3, item1, item2])
    end

    it "sorts by price high to low" do
      results = Item.search({ sort: "price_high_to_low" })
      expect(results).to eq([item2, item1, item3])
    end

    it "sorts by oldest" do
      results = Item.search({ sort: "oldest" })
      expect(results).to eq([item1, item2, item3])
    end

    it "uses relevance sort when keyword present and sort not specified" do
      results = Item.search({ keyword: "Lamp" })
      expect(results.first).to eq(item1)
    end

    it "uses newest sort when no keyword and sort not specified" do
      results = Item.search({})
      expect(results.first).to eq(item3)
    end
  end

  describe ".autocomplete" do
    let!(:item1) { Item.create!(valid_attributes.merge(name: "Lamp")) }
    let!(:item2) { Item.create!(valid_attributes.merge(name: "Lamp Shade")) }
    let!(:item3) { Item.create!(valid_attributes.merge(name: "Desk Lamp")) }
    let!(:item4) { Item.create!(valid_attributes.merge(name: "Table")) }

    it "returns empty array when keyword is blank" do
      expect(Item.autocomplete("")).to eq([])
    end

    it "returns matching item names" do
      suggestions = Item.autocomplete("Lamp")
      expect(suggestions).to include("Lamp", "Lamp Shade", "Desk Lamp")
      expect(suggestions).not_to include("Table")
    end

    it "respects limit parameter" do
      suggestions = Item.autocomplete("Lamp", limit: 2)
      expect(suggestions.size).to be <= 2
    end

    it "returns names ordered by priority and rank" do
      suggestions = Item.autocomplete("Lamp")
      # Exact prefix match should come first
      expect(suggestions.first).to eq("Lamp")
    end

    it "returns unique names" do
      Item.create!(valid_attributes.merge(name: "Lamp"))
      suggestions = Item.autocomplete("Lamp")
      expect(suggestions.count("Lamp")).to eq(1)
    end
  end

  describe ".available_seller_locations" do
    it "returns the list of college locations from User model" do
      expect(Item.available_seller_locations).to eq(User::COLLEGE_LOCATIONS)
    end
  end

  describe ".sort" do
    let!(:item1) { Item.create!(valid_attributes.merge(price: 100, created_at: 5.days.ago, post_date: 5.days.ago)) }
    let!(:item2) { Item.create!(valid_attributes.merge(price: 50, created_at: 3.days.ago, post_date: 3.days.ago)) }
    let!(:item3) { Item.create!(valid_attributes.merge(price: 200, created_at: 1.day.ago, post_date: 1.day.ago)) }

    it "sorts by oldest" do
      sorted = Item.sort(Item.all, "oldest")
      expect(sorted).to eq([item1, item2, item3])
    end

    it "sorts by price low to high" do
      sorted = Item.sort(Item.all, "price_low_to_high")
      expect(sorted).to eq([item2, item1, item3])
    end

    it "sorts by price high to low" do
      sorted = Item.sort(Item.all, "price_high_to_low")
      expect(sorted).to eq([item3, item1, item2])
    end

    it "defaults to newest for invalid sort option" do
      sorted = Item.sort(Item.all, "invalid_sort")
      expect(sorted).to eq([item3, item2, item1])
    end
  end
end