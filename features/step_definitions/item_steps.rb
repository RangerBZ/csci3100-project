When /^I create item "([^"]*)" with category "([^"]*)", price "([^"]*)"$/ do |name,category,price|
  steps %{
    When I follow "Post my own item"
    When I fill in "item_name" with "#{name}"
    When I select "#{category}" from "item_category"
    When I fill in "item_price" with "#{price}"
    When I fill in "item_description" with "no description"
    When I press "Post item"
    When I follow "← Back to Market"
    Then I should see "#{name}"
  }
end

When ('the following items exists:') do |items_table|
  @all_items=items_table
  items_table.hashes.each do |item_params|
    steps %{
      Then I login using account "#{item_params[:owner]}" with password "111111"
      When I create item "#{item_params[:name]}" with category "#{item_params[:category]}", price "#{item_params[:price]}"
      When I log out
    }
  end
end

Then /^I should see all items$/ do
  @all_items.hashes.each do |item_params|
    expect(page.body).to have_content(item_params[:name])
  end
end

Then /^item "([^"]*)" should be in state "([^"]*)"$/ do |name, state|
  expect(find("div[data-name='#{name}']").text).to have_content(state)
end