When /^I registered account "([^"]*)" with email name "([^"]*)", password "([^"]*)"$/ do |name, email, password|
  steps %{
	When I follow "Register a new account"
	When I fill in "user_name" with "#{name}"
	When I fill in "user_email" with "#{email}@link.cuhk.edu.hk"
	When I select "Chung Chi College" from "user_location"
	When I fill in "password" with "#{password}"
	When I fill in "password_confirmation" with "#{password}"
	When I press "Register"
  	Then I should see "User was successfully created!"
  }
end

When /^I registered account "([^"]*)" with email name "([^"]*)", password "([^"]*)", location "([^"]*)"$/ do |name, email, password, location|
  steps %{
	When I follow "Register a new account"
	When I fill in "user_name" with "#{name}"
	When I fill in "user_email" with "#{email}@link.cuhk.edu.hk"
	When I select "#{location}" from "user_location"
	When I fill in "password" with "#{password}"
	When I fill in "password_confirmation" with "#{password}"
	When I press "Register"
  	Then I should see "User was successfully created!"
  }
end

When /^I login using account "([^"]*)" with password "([^"]*)"$/ do |name, password|
  steps %{
    When I fill in "name" with "#{name}"
    When I fill in "password" with "#{password}"
    When I press "Login"
  	Then I should see "Hello #{name}!"
  }
end

When /^I log out$/ do
  click_link("Log Out")
end