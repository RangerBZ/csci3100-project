require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes legacy college locations to full english names" do
    user = User.new(
      name: "daisy",
      email: "daisy@link.cuhk.edu.hk",
      location: "new asia",
      password: "password123",
      password_confirmation: "password123"
    )

    user.valid?

    assert_equal "New Asia College", user.location
  end

  test "rejects email addresses outside the cuhk link domain" do
    user = User.new(
      name: "invalid-email-user",
      email: "student@gmail.com",
      location: "New Asia College",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not user.valid?
    assert_includes user.errors[:email], "must end with @link.cuhk.edu.hk"
  end

  test "accepts link.cuhk.edu.hk email addresses" do
    user = User.new(
      name: "valid-email-user",
      email: "student@link.cuhk.edu.hk",
      location: "United College",
      password: "password123",
      password_confirmation: "password123"
    )

    assert user.valid?
  end
end
