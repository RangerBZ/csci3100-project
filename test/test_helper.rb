ENV["RAILS_ENV"] ||= "test"

require "simplecov"
SimpleCov.start "rails" do
  add_filter "/bin/"
  add_filter "/db/"
  add_filter "/spec/"
end

require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    include ActiveSupport::Testing::TimeHelpers

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
