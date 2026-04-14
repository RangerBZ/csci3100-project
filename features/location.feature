Feature: user can find locations
  As a user
  So that I can find locations of the items
  I want the to see the locations on the map

Scenario: directly find locations

  Given I am on the home page
  When I registered account "david" with email name "1155444444", password "222222"
  Then I login using account "david" with password "222222"
  When I follow "All Locations"
  Then I should see "Location List (Click to view each)"
  When I follow "Shaw College"
  Then I should see "Location Details"
  Then I should see "Shaw College"

Scenario: find locations from items

  Given I am on the home page
  When I registered account "derek" with email name "1155333333", password "111111", location "New Asia College"
  Then I login using account "derek" with password "111111"
  When I create item "scissors" with category "Other", price "20"
  Then "scissors" should appear before "New Asia College"
  When I follow "New Asia College" in "scissors"
  Then I should see "Location Details"
  Then I should see "New Asia College"

