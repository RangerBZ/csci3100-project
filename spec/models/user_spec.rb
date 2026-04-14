# This whole file was originally AI generated (before Apr. 14th 16:53). 
# This file is now fully reviewed and modified by hand
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) do
    {
      name: "testuser",
      email: "testuser@link.cuhk.edu.hk",
      password: "password",
      password_confirmation: "password",
      location: "Chung Chi College"
    }
  end

  describe "validations" do
    it "is valid with valid attributes" do
      user = User.new(valid_attributes)
      expect(user).to be_valid
    end

    it "is invalid without a name" do
      user = User.new(valid_attributes.merge(name: nil))
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "is invalid without a email" do
      user = User.new(valid_attributes.merge(email: nil))
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "requires unique name" do
      User.create!(valid_attributes)
      duplicate_user = User.new(valid_attributes.merge(email: "different@link.cuhk.edu.hk"))
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:name]).to include("has already been taken")
    end

    it "requires unique email" do
      User.create!(valid_attributes)
      duplicate_user = User.new(valid_attributes.merge(name: "differentuser"))
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include("has already been taken")
    end

    describe "email format" do
      it "accepts valid @link.cuhk.edu.hk emails" do
        valid_emails = [
          "student@link.cuhk.edu.hk",
          "test123@link.cuhk.edu.hk",
          "a.b@link.cuhk.edu.hk"
        ]
        valid_emails.each do |email|
          user = User.new(valid_attributes.merge(email: email))
          expect(user).to be_valid, "Expected #{email} to be valid"
        end
      end

      it "rejects invalid email formats" do
        invalid_emails = [
          "test@gmail.com",
          "test@cuhk.edu.hk",
          "test@link.cuhk.edu",
          "testlink.cuhk.edu.hk",
          "test@.com"
        ]
        invalid_emails.each do |email|
          user = User.new(valid_attributes.merge(email: email))
          expect(user).not_to be_valid
          expect(user.errors[:email]).to include("must end with @link.cuhk.edu.hk")
        end
      end
    end

    describe "password validations" do
      it "requires password on create" do
        user = User.new(valid_attributes.except(:password))
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("can't be blank")
      end

      it "requires password confirmation on create when password is present" do
        user = User.new(valid_attributes.merge(password_confirmation: "wrong"))
        expect(user).not_to be_valid
      end

      it "requires password length of at least 6 characters on create" do
        user = User.new(valid_attributes.merge(password: "short", password_confirmation: "short"))
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
      end

      it "does not require password on update" do
        user = User.create!(valid_attributes)
        user.update(name: "newname")
        expect(user).to be_valid
      end
    end
  end

  describe "callbacks" do
    describe "#normalize_location" do
      it "normalizes legacy location names to full college names" do
        legacy_mappings = {
          "chung chi" => "Chung Chi College",
          "new asia" => "New Asia College",
          "united" => "United College",
          "shaw" => "Shaw College",
          "morningside" => "Morningside College",
          "s.h. ho" => "S.H. Ho College",
          "cw chu" => "CW Chu College",
          "wu yee sun" => "Wu Yee Sun College",
          "lee woo sing" => "Lee Woo Sing College"
        }

        legacy_mappings.each do |input, expected|
          user = User.new(valid_attributes.merge(location: input))
          user.valid?
          expect(user.location).to eq(expected)
        end
      end

      it "leaves valid college names unchanged" do
        valid_locations = User::COLLEGE_LOCATIONS
        valid_locations.each do |location|
          user = User.new(valid_attributes.merge(location: location))
          user.valid?
          expect(user.location).to eq(location)
        end
      end

      it "handles case-insensitive legacy mappings" do
        user = User.new(valid_attributes.merge(location: "CHUNG CHI"))
        user.valid?
        expect(user.location).to eq("Chung Chi College")
      end

      it "leaves unknown locations unchanged" do
        user = User.new(valid_attributes.merge(location: "Unknown Location"))
        user.valid?
        expect(user.location).to eq("Unknown Location")
      end

      it "handles blank location" do
        user = User.new(valid_attributes.merge(location: ""))
        user.valid?
        expect(user.location).to eq("")
      end
    end
  end

  describe ".find_seller_id" do
    let!(:user1) { User.create!(valid_attributes.merge(name: "John Doe")) }
    let!(:user2) { User.create!(valid_attributes.merge(name: "Jane Smith", email: "jane@link.cuhk.edu.hk")) }

    it "finds user by partial name match case-insensitively" do
      expect(User.find_seller_id("john")).to eq(user1.id)
      expect(User.find_seller_id("JOHN")).to eq(user1.id)
      expect(User.find_seller_id("jane")).to eq(user2.id)
    end

    it "returns nil when no user matches" do
      expect(User.find_seller_id("nonexistent")).to be_nil
    end

    it "strips whitespace from input" do
      expect(User.find_seller_id("  john  ")).to eq(user1.id)
    end

    it "returns the first matching user when multiple match" do
      User.create!(valid_attributes.merge(name: "John Smith", email: "john2@link.cuhk.edu.hk"))
      result = User.find_seller_id("john")
      expect(result).to eq(user1.id) # returns first match
    end
  end

  describe "#generate_password_reset_code!" do
    let(:user) { User.create!(valid_attributes) }

    it "generates a 6-digit numeric reset code" do
      user.generate_password_reset_code!
      expect(user.password_reset_code).to match(/\A\d{6}\z/)
    end

    it "saves the changes to database" do
      user.generate_password_reset_code!
      user.reload
      expect(user.password_reset_code).not_to be_nil
      expect(user.password_reset_expires_at).not_to be_nil
    end

    it "overwrites existing reset code" do
      user.generate_password_reset_code!
      first_code = user.password_reset_code
      user.generate_password_reset_code!
      expect(user.password_reset_code).not_to eq(first_code)
    end
  end

  describe "#clear_password_reset_code!" do
    let(:user) { User.create!(valid_attributes) }

    before do
      user.generate_password_reset_code!
    end

    it "clears the password reset code" do
      user.clear_password_reset_code!
      expect(user.password_reset_code).to be_nil
    end

    it "clears the expiration time" do
      user.clear_password_reset_code!
      expect(user.password_reset_expires_at).to be_nil
    end

    it "saves the changes to database" do
      user.clear_password_reset_code!
      user.reload
      expect(user.password_reset_code).to be_nil
      expect(user.password_reset_expires_at).to be_nil
    end
  end

  describe "constants" do
    it "defines COLLEGE_LOCATIONS with 9 colleges" do
      expect(User::COLLEGE_LOCATIONS.size).to eq(9)
      expect(User::COLLEGE_LOCATIONS).to include(
        "Chung Chi College",
        "New Asia College",
        "United College",
        "Shaw College",
        "Morningside College",
        "S.H. Ho College",
        "CW Chu College",
        "Wu Yee Sun College",
        "Lee Woo Sing College"
      )
    end

    it "defines LEGACY_LOCATION_MAPPINGS with 18 entries" do
      expect(User::LEGACY_LOCATION_MAPPINGS.size).to eq(18)
    end
  end
end