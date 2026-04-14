When /^I find the detail of "([^"]*)"$/ do |name|
  find("div[data-name='#{name}']").click_link('more info ->')
end

When /^I purchase the item "([^"]*)"$/ do |name|
  find("div[data-name='#{name}']").click_link('more info ->')
  click_link("Purchase")
end

When /^I add the item "([^"]*)" to favorites$/ do |name|
  expect(find("div[data-name='#{name}']").text).to have_content('☆')
  find("div[data-name='#{name}']").click_button('☆')
  expect(find("div[data-name='#{name}']").text).to have_content('★')
end

When /^I remove the item "([^"]*)" to favorites$/ do |name|
  expect(find("div[data-name='#{name}']").text).to have_content('★')
  find("div[data-name='#{name}']").click_button('★')
  expect(find("div[data-name='#{name}']").text).to have_content('☆')
end

When /^I follow "([^"]*)" in "([^"]*)"$/ do |text,name|
  expect(find("div[data-name='#{name}']").text).to have_content(text)
  find("div[data-name='#{name}']").click_link(text)
end

When /^I log out$/ do
  click_link("Log Out")
end