# Given /database is loaded with dummy cities/ do |cities_table|
#   cities_table.hashes.each do |city|
#     Movie.create movie
#   end
# end

When /^my location is set to "(.*)"$/ do |place| 
  find('#pac-input').set(place)
  find('#pac-input').native.send_keys(:Enter)
end


And /^I visit multiple locations:(.*)$/ do |cities|
  city_list = cities.split(',')
  city_list.each do |city|
    steps %Q{When my location is set to "#{city}"}
  end
end

Then /I should see the details of "(.*)"/ do |city_name|
  pending
end

Then /I expect to see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body.index(e1) < page.body.index(e2))
end

Given(/^I touch the add marker CTA$/) do
  find("#marker-cta").click
end

Given(/^I click on the map$/) do
  page.find("#map").click # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see "([^"]*)", when it loads$/) do |arg1|
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


Then /I should see "(.*)" above "(.*)"$/ do |city1, city2|
  #  ensure that that city1 occurs before city2.
  #  page.body is the entire content of the page as a string.
  expect page.body.match ("^.*#{city1}.*#{city2}")
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

# TESTS THAT USE THIS STEP DEF MUST TAG SCENARIO WITH '@omniauth_google_login' set in /breathe-cal/features/support/hooks.rb
Given /^(?:|I )successfully authenticated with Google as "([^"]*)"$/ do |name|
  @user_hash[:info][:name] = name
  OmniAuth.config.add_mock(:google_oauth2, @user_hash)
  steps %Q{
    Given I am on the landing page
    Then I follow "Sign in with Google+"
  }
  # visit auth_test_path(:info => {:name=>name})
  # visit auth_test_path(:name => name, :test_check => true)
end

# TESTS THAT USE THIS STEP DEF MUST TAG SCENARIO WITH '@omniauth_google_login' set in /breathe-cal/features/support/hooks.rb
Given /^(?:|I )fail to login$/ do 
  OmniAuth.config.mock_auth[:google_oauth2] = :Invalid_Credentials
  steps %Q{
    Given I am on the landing page
    Then I follow "Sign in with Google+"
  }
end
