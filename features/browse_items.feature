Feature: user can filter and sort items

  As a user
  So that I can filter and sort items
  I want the items being showed to me as the way I want

Scenario: item sorting by Price

  Given I am on the home page
  When I registered account "alice" with email name "1155111111", password "111111", location "Chung Chi College"
  When I registered account "bob" with email name "1155222222", password "111111", location "United College"
  When I registered account "derek" with email name "1155333333", password "111111", location "New Asia College"
  When the following items exists:
    | name     | category    | price | owner |
    | battery  | Electronics | 10    | alice |
    | fan      | Furniture   | 20    | bob   |
    | scissors | Other       | 20    | derek |
    | textbook | Books       | 30    | alice |
    | shirt    | Clothing    | 30    | bob   |
    | football | Sports      | 40    | derek |
    | baseball | Sports      | 50    | alice |
    | camera   | Electronics | 50    | bob   |
    | trousers | Clothing    | 60    | derek |
  When I registered account "david" with email name "1155444444", password "222222"
  Then I login using account "david" with password "222222"
  Then I should see all items
  When I select "Price: low to high" from "sort"
  When I press "Search items"
  Then "battery" should appear before "fan"
  Then "battery" should appear before "scissors"
  Then "fan" should appear before "textbook"
  Then "scissors" should appear before "textbook"
  When I select "Price: high to low" from "sort"
  When I press "Search items"
  Then "trousers" should appear before "camera"
  Then "trousers" should appear before "baseball"
  Then "baseball" should appear before "football"
  Then "camera" should appear before "football"

Scenario: item sorting by time

  Given I am on the home page
  When I registered account "alice" with email name "1155111111", password "111111", location "Chung Chi College"
  When I registered account "bob" with email name "1155222222", password "111111", location "United College"
  When I registered account "derek" with email name "1155333333", password "111111", location "New Asia College"
  When the following items exists:
    | name     | category    | price | owner |
    | battery  | Electronics | 10    | alice |
    | fan      | Furniture   | 20    | bob   |
    | scissors | Other       | 20    | derek |
    | textbook | Books       | 30    | alice |
    | shirt    | Clothing    | 30    | bob   |
    | football | Sports      | 40    | derek |
    | baseball | Sports      | 50    | alice |
    | camera   | Electronics | 50    | bob   |
    | trousers | Clothing    | 60    | derek |
  When I registered account "david" with email name "1155444444", password "222222"
  Then I login using account "david" with password "222222"
  Then I should see all items
  When I select "Oldest first" from "sort"
  When I press "Search items"
  Then "battery" should appear before "fan"
  Then "fan" should appear before "scissors"
  Then "scissors" should appear before "textbook"
  Then "textbook" should appear before "shirt"
  When I select "Newest first" from "sort"
  When I press "Search items"
  Then "shirt" should appear before "textbook"
  Then "textbook" should appear before "scissors"
  Then "scissors" should appear before "fan"
  Then "fan" should appear before "battery"

Scenario: item filtering by category

  Given I am on the home page
  When I registered account "alice" with email name "1155111111", password "111111", location "Chung Chi College"
  When I registered account "bob" with email name "1155222222", password "111111", location "United College"
  When I registered account "derek" with email name "1155333333", password "111111", location "New Asia College"
  When the following items exists:
    | name     | category    | price | owner |
    | battery  | Electronics | 10    | alice |
    | fan      | Furniture   | 20    | bob   |
    | scissors | Other       | 20    | derek |
    | textbook | Books       | 30    | alice |
    | shirt    | Clothing    | 30    | bob   |
    | football | Sports      | 40    | derek |
    | baseball | Sports      | 50    | alice |
    | camera   | Electronics | 50    | bob   |
    | trousers | Clothing    | 60    | derek |
  When I registered account "david" with email name "1155444444", password "222222"
  Then I login using account "david" with password "222222"
  When I select "Furniture" from "category"
  When I press "Search items"
  Then I should see "fan"
  Then I should not see "battery"
  When I follow "Clear filters"
  Then I should see all items

Scenario: item filtering by location and price

  Given I am on the home page
  When I registered account "alice" with email name "1155111111", password "111111", location "Chung Chi College"
  When I registered account "bob" with email name "1155222222", password "111111", location "United College"
  When I registered account "derek" with email name "1155333333", password "111111", location "New Asia College"
  When the following items exists:
    | name     | category    | price | owner |
    | battery  | Electronics | 10    | alice |
    | fan      | Furniture   | 20    | bob   |
    | scissors | Other       | 20    | derek |
    | textbook | Books       | 30    | alice |
    | shirt    | Clothing    | 30    | bob   |
    | football | Sports      | 40    | derek |
    | baseball | Sports      | 50    | alice |
    | camera   | Electronics | 50    | bob   |
    | trousers | Clothing    | 60    | derek |
  When I registered account "david" with email name "1155444444", password "222222"
  Then I login using account "david" with password "222222"
  When I select "New Asia College" from "seller_location"
  When I press "Search items"
  Then I should see "scissors"
  Then I should not see "fan"
  When I fill in "min_price" with "20"
  When I fill in "max_price" with "50"
  When I press "Search items"
  Then I should see "scissors"
  Then I should see "football"
  Then I should not see "textbook"
  Then I should not see "camera"
  Then I should not see "fan"

Scenario: item filtering by availability

  Given I am on the home page
  When I registered account "alice" with email name "1155111111", password "111111", location "Chung Chi College"
  When I registered account "bob" with email name "1155222222", password "111111", location "United College"
  When I registered account "derek" with email name "1155333333", password "111111", location "New Asia College"
  When the following items exists:
    | name     | category    | price | owner |
    | battery  | Electronics | 10    | alice |
    | fan      | Furniture   | 20    | bob   |
    | scissors | Other       | 20    | derek |
    | textbook | Books       | 30    | alice |
    | shirt    | Clothing    | 30    | bob   |
    | football | Sports      | 40    | derek |
    | baseball | Sports      | 50    | alice |
    | camera   | Electronics | 50    | bob   |
    | trousers | Clothing    | 60    | derek |
  When I registered account "david" with email name "1155444444", password "222222"
  Then I login using account "david" with password "222222"
  When I find the detail of "battery"
  Then I should see "Description"
  Then I should see "Posted Date"
  When I follow "Purchase"
  When I follow "← Back to Market"
  Then item "battery" should be in state "sold"
  When I select "Sold" from "status"
  When I press "Search items"
  Then I should see "battery"
  Then I should not see "textbook"
  Then I should not see "camera"

Scenario: item deletion

  Given I am on the home page
  When I registered account "alice" with email name "1155111111", password "111111", location "Chung Chi College"
  When I registered account "bob" with email name "1155222222", password "111111", location "Chung Chi College"
  Then I login using account "alice" with password "111111"
  When I create item "baseball" with category "Sports", price "20"
  When I log out
  Then I login using account "bob" with password "111111"
  When I find the detail of "baseball"
  Then I should not see "Delete Item"
  When I follow "← Back to Market"
  When I log out
  Then I login using account "alice" with password "111111"
  When I find the detail of "baseball"
  Then I should see "Delete Item"
  When I follow "Delete Item"
  Then I should not see "baseball"
  When I log out
  Then I login using account "bob" with password "111111"
  Then I should not see "baseball"