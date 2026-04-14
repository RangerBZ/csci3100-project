Feature: user can change their information

  As a user who mistakenly uploaded wrong information
  So that I can correct my information
  I want my items' information change along with my profile

Scenario: chaging name and location

  Given I am on the home page
  When I registered account "alice" with email name "1155111111", password "111111", location "Chung Chi College"
  When I registered account "derek" with email name "1155222222", password "111111", location "Chung Chi College"
  Then I login using account "alice" with password "111111"
  When I create item "baseball" with category "Sports", price "20"
  Then "baseball" should appear before "Chung Chi College"
  When I follow "View My Profile"
  Then I should see "alice"
  Then I should see "Chung Chi College"
  When I follow "Edit Profile"
  Then I should see "Update your account details below"
  When I fill in "user_name" with "derek"
  When I press "Save Changes"
  Then I should see "Name has already been taken"
  When I fill in "user_name" with "bob"
  When I select "Shaw College" from "user_location"
  When I press "Save Changes"
  Then I should see "Shaw College"
  When I follow "← Back to Market"
  Then I should see "Hello bob!"
  Then "baseball" should appear before "Shaw College"

Scenario: chaging password

  Given I am on the home page
  When I registered account "alice" with email name "1155111111", password "111111", location "Chung Chi College"
  Then I login using account "alice" with password "111111"
  When I follow "View My Profile"
  When I follow "Edit Profile"
  Then I should see "Update your account details below"
  When I fill in "user_password" with "222222"
  When I fill in "user_password_confirmation" with "333333"
  When I press "Save Changes"
  Then I should see "Password confirmation doesn't match Password"
  When I fill in "user_password" with "222222"
  When I fill in "user_password_confirmation" with "222222"
  When I press "Save Changes"
  Then I should see "Member Profile"
  When I follow "← Back to Market"
  Then I should see "Hello alice!"
  When I log out
  Then I login using account "alice" with password "111111" should fail
  Then I login using account "alice" with password "222222"

Scenario: chaging email

  Given I am on the home page
  When I registered account "alice" with email name "1155111111", password "111111", location "Chung Chi College"
  When I registered account "bob" with email name "1155222222", password "111111", location "Chung Chi College"
  Then I login using account "alice" with password "111111"
  When I follow "View My Profile"
  When I follow "Edit Profile"
  Then I should see "Update your account details below"
  When I fill in "user_email" with "aaa@qq.com"
  When I press "Save Changes"
  Then I should see "Email must end with @link.cuhk.edu.hk"
  When I fill in "user_email" with "1155222222@link.cuhk.edu.hk"
  When I press "Save Changes"
  Then I should see "Email has already been taken"
  When I fill in "user_email" with "1155333333@link.cuhk.edu.hk"
  When I press "Save Changes"
  Then I should see "Member Profile"
  When I follow "← Back to Market"
  Then I should see "Hello alice!"
  When I log out
  When I follow "Forgot password?"
  Then I should see "Enter your email address"
  When I fill in "email" with "1155111111@link.cuhk.edu.hk"
  When I press "Send Verification Code"
  Then I should see "User not found. Please check your email address."
  When I fill in "email" with "1155333333@link.cuhk.edu.hk"
  When I press "Send Verification Code"
  Then I should see "Enter Verification Code"

