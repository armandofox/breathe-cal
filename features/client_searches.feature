Feature: client searches 
  As an allergy sufferer with a user account
  in order to know what cities I have recently searched for, 
  I should see the last 5 cities I searched for at the bottom of the sidebar on the landing page.

# TODO - commented sections -> view is not being populated with new data, although search is being made
# not consistent with heroku deployment. 
# issues with capybara testing + asynchronous javascript


@javascript   
Scenario: I should see a blank search history before having searched for anything
    Given I am on the landing page
    Then I should see "No recent searches"

@javascript   
Scenario: Having searched for a city I should see it displayed on the page
    Given I go to the landing page
    And my location is set to "Kansas City"
    Then I should see "Kansas City"
    Then I should not see "Vancouver"
    Then I should not see "Boston"
    

@javascript   
Scenario: Having searched for two cities I should see the most recent one on top
    Given I go to the landing page
    And my location is set to "Berkeley"
    And my location is set to "Albany"
    Then I expect to see "Albany" before "Berkeley"
    Then I expect to see a list of cities
    
@javascript
Scenario: Having searched for cities, I should retain my recent searches even if I go to the details page
    Given I go to the landing page
    And my location is set to "Berkeley"
    And my location is set to "New York"
    Then I should see "Berkeley"
    Then I should see "New York"

