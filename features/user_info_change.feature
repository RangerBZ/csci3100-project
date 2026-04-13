
Feature: user can change their information

  As a user who mistakenly uploaded wrong information
  So that I can correct my information
  I want my items' information change along with my profile

Scenario: chaging profile

  Given I am on the home page
  When I registered account "alice" with email name "1155111111", password "111111", location "Chung Chi College"
  When I login using account "alice" with password "111111"
  When I create item "baseball" with category "Sports", price "20"
  Then "baseball" should appear before "Chung Chi College"
  When I follow "View My Profile"
  Then I should see "alice"
  Then I should see "Chung Chi College"
  When I follow "Edit Profile"
  Then I should see "Update your account details below"
  When I fill in "user_name" with "bob"
  When I select "Shaw College" from "user_location"
  When I press "Save Changes"
  Then I should see "Shaw College"
  When I follow "← Back to Market"
  Then I should see "Hello bob!"
  Then "baseball" should appear before "Shaw College"
