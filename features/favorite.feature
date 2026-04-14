Feature: user can add and remove favorite items
  As a user
  So that I can add and remove favorite items
  I want the items appear in my favorites

Scenario: adding favorite items

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
  When I add the item "fan" to favorites
  When I follow "My Favorites"
  Then I should see "fan"
  When I follow "← Back to Items"
  When I remove the item "fan" to favorites
  When I follow "My Favorites"
  Then I should not see "fan"