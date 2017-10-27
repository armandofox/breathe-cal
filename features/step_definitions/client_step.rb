Given /the following clients exist/ do |users_table|
  users_table.hashes.each do |user|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  Client.create!(user)
  end
  # fail "Unimplemented"
end

Given /I as "(.*)" have searched for "(.*)"$/ do |user, city|
    #we will implement this model method later
    User.addToUser(user, city)
end

And /I should see "(.*)" above "(.*)"$/ do |city1, city2|
  #  ensure that that city1 occurs before city2.
  #  page.body is the entire content of the page as a string.
  #fail "Unimplemented"
  expect page.body.match ("^.*#{city1}.*#{city2}")
end

# Then /I should see an empty search history/ do
#     #pending
# end 

Then /I should be on the user homepage/ do
  #pending
end

Given /I am on the sign_in page/ do
  #pending
end 

Given /I am on the sign_up page/ do
  #pending
end 

Then /I print the page/ do
  print page.html
end

Then /^(?:|I )should see the button "([^"]*)"$/ do |text|
  #pending
end


Then /^(?:|I )should see the link "([^"]*)"$/ do |link|
  find_link(link).visible?
end

When /^(?:|I )press the icon "([^"]*)"$/ do |icon|
  find('img.gmail_icon').click
end

Given /^(?:|I )successfully authenticated with Google as "([^"]*)"$/ do |name|
  # Adding info to google mock that is set in /breathe-cal/features/support/hooks.rb
  # OmniAuth.config.add_mock(:google_oauth2, {:info => {:email=>"test@xxxx.com", :name=>name}})
  visit auth_test_path(:name => name)
  # visit auth_test_path(:name => name, :test_check => true)
end

Given /skip/ do
  skip_this_scenario
end

Given /^(?:|I )am logged in as "([^"]*)"$/ do |name|
  visit auth_test_path(:name => name, :test_check => true)
end 

