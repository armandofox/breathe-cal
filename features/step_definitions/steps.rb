


Given(/^I touch the add marker CTA$/) do
  find("#marker-cta").click
end

Given(/^I click on the map$/) do
  page.find("#map").click # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see "([^"]*)" when it loads$/) do |arg1|
  wait_for_ajax
  wait_until { page.has_content?(arg1)}
  if page.respond_to? :should
    page.should have_content(arg1)
  else
    assert page.has_content?(arg1)
  end
end


def wait_until
  require "timeout"
  Timeout.timeout(Capybara.default_max_wait_time) do
    sleep(0.1) until value = yield
    value
  end
end

def wait_for_ajax
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until finished_all_ajax_requests?
  end
end

def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
end

Given /the following clients exist/ do |users_table|
  # users_table.hashes.each do |user|
  #   # each returned element will be a hash whose key is the table header.
  #   # you should arrange to add that movie to the database here.
  # # Client.create!(user)
  # # end
  # fail "Unimplemented"
  #pending
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
  visit auth_test_path(:name => name)
end 

Then /^(?:|I )should see "([^"]*)" or "([^"]*)"$/ do |text1, text2|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text1) || page.has_content?(text2)
  end
end

Given /^I am signed in$/ do
  # pending
end

Given /^I am not signed in$/ do
  # pending
end

Given /^the site is set up $/ do
  # pending
end

Given /^ I see a list of cities in the dropdown  $/ do
  # pending
end

Given /^ I see a list of cities in my favorites list   $/ do
  # pending
end

Given /^ there are cities shown $/ do
  # pending
end

When  /^ I click on "(.*?)"$/ do |arg1|
  # pending
end

Then /^I should see city ".*?"$/ do |arg1|
  # pending
end

Then /^I should see information about “.*?”$/ do |arg1|
  # pending
end

Then /^I should not see “.*?”$/ do |arg1|
  # pending
end

Then /^I should see “.*?”$/ do |arg1|
  # pending
end

Then /^I should see a link “.*?”$/ do |link|
  # pending
end

Then /^I should see icon “.*?”$/ do |arg1|
  # pending
end

Then /^I click on the plus sign besides the city$/ do |arg1|
  # pending
end

Then /^I should see the plus sign changes into a check mark$/ do |arg1|
  # pending
end

When /^I search for a city “.*?” $/ do |arg1|
  # pending
end

When /^I should see “.*?” on the list of autocompleted cities  $/ do |arg1|
  # pending
end

When /^I should see nearby cities $/ do |arg1|
  # pending
end

When /^I am on the city detail page of “.*?”$/ do |arg1|
  # pending
end

Then /^I should see plus button$/ do 
  # pending
end

Then /^I follow plus button$/ do 
  # pending
end

Then /^ I should go to sign in page$/ do 
  # pending
end

Then /^ I finished signed in$/ do 
  # pending
end

Then /^ I should see check button$/ do 
  # pending
end

Then /^ I should see text in the “.*?” section $/ do 
  # pending
end

Then /^ I should not see plus button$/ do 
  # pending
end

When /^ I am on the city list page$/ do 
  # pending
end

When /^ I have “.*?” in my list$/ do 
  # pending
end

When /^ I click on “.*?” allergy  $/ do 
  # pending
end

And /^ user is on the “.*?” details page $/ do 
  # pending
end








And /^that the cities that have been added: "(.*?)", "(.*?)", "(.*?)"$/ do |arg1, arg2, arg3|
  # pending
end

Given /^that I am on the city list page$/ do
  # pending
end

Then /^I should see city ".*?"$/ do |arg1|
  # pending
end

And /^I should see city ".*?"$/ do |arg1|
  # pending
end

And /^I should not see city ".*?"$/ do |arg1|
  # pending
end

Given /^that I press X on city “.*?”$/ do |arg1|
  # pending
end

Then(/^I should see a "map"$/) do
  assert page.find("#map")
end

Then(/^I should see an "search box" in the map$/) do
  assert page.find("#pac-input")
end

Then(/^I should see the right toolbar with the text "([^"]*)"$/) do |arg1|
  assert_equal(page.find("#pac-input").text, arg1)
end

When(/^I should see a "(.+)"$/) do |image|
  page.should have_xpath("//img[contains(@src, \"#{image.split('-')[0]}\")]")
end


When(/^I should see a "date"$/) do
  
end

Given(/^I have searched for "([^"]*)"$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I should see a "(.+)"$/) do |image|
  page.should have_xpath("//img[contains(@src, \"#{image.split('-')[0]}\")]")
end

And(/^I should see an icon "(.+)"$/) do |image|
  page.should have_xpath("//img[contains(@src, \"#{image.split('-')[0]}\")]")
end


And(/^I should see a weather icon inside/) do 
  page.should have_xpath("//img[contains(@src, \"#{"-s".split('-')[0]}\")]")
end

And(/^I should see the weather section/) do 
  page.should have_css('div#weather-box')
end

And(/^I should see the greeting section/) do 
  page.should have_css('div#fox-box')
end

And(/^I should see the alert section/) do 
  page.should have_css('div#fox-box')
end

And(/^I should see the date/) do 
  page.should have_css('div.datetime-box')
end

Then(/^I should see a map$/) do
  page.evaluate_script('map') 
end

Then /^(?:|I )should see the text on the side "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

And(/^my location is set to "([^"]*)"$/) do |place| 
  find('#pac-input').set(place)
  find('#pac-input').native.send_keys(:Enter)
end

Given(/^I press on the text "([^"]*)"$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

And(/^(?:I expect a Google map to load|the map has been loaded)$/) do  
  page.evaluate_script('map') 
end  

Then(/^the center of the map should be approximately "([^"]*)"$/) do |place|  
  find('#fox-box').has_text?(place)
end  


Then(/^the center of the map should not be approximately "([^"]*)"$/) do |place|  
  not find('#fox-box').has_text?(place)
end  
