Feature: client searches 
  As an allergy sufferer with a user account
  in order to know what cities I have recently searched for, 
  I should see the last 5 cities I searched for at the bottom of the sidebar on the landing page.


@javascript   
Scenario: I should see a blank search history before having searched for anything
    Given I am on the landing page
    Then I should see "No recent searches"

@javascript   
Scenario: Having searched for a city I should see it displayed on the page
    Given I go to the landing page
    And my location is set to "Kansas City"
    And I follow "Back" 
    Then I should see "Kansas City"
    Then I should not see "Vancouver"
    Then I should not see "Boston"
    #When I follow a recently searched link: "Kansas City"
    #Then I should see the details of "Berkeley"
    

@javascript   
Scenario: Having searched for two cities I should see the most recent one on top
    Given I go to the landing page
    And my location is set to "Berkeley"
    And I follow "Back"
    And my location is set to "Albany"
    And I follow "Back"
    Then I expect to see "Albany" before "Berkeley"
    # Then I should see the text on the side "Berkeley"
    # Then I should see the text on the side "Albany"
    # And I should see "Berkeley" above "Albany"    
    
# @javascript
# Scenario: Having searched for cities, I should retain my recent searches even if I go to the details page
#     Given I go to the landing page
#     And my location is set to "Berkeley"
#     And my location is set to "New York"
#     And I follow "Back"
#     Then I should see "Berkeley"
#     #And I follow a recently searched link: "Berkeley" 
#     #And I follow "Back"

@javascript    
Scenario: Having searched for more than 5 cities I should only see the last 5 ones displayed
    Given I go to the landing page
    And I visit multiple locations: Berkeley, Albany, Oakland, Richmond, San Jose, Los Angeles
    And my location is set to "Berkeley"
    And my location is set to "Albany"
    And my location is set to "Oakland"
    And my location is set to "Richmond"
    And my location is set to "San Jose"
    And my location is set to "Los Angeles"
    And I follow "Back"
    # Then I should see "Albany"
    # Then I should see "Oakland"
    # Then I should see "Richmond"
    # Then I should see "San Jose"
    # Then I should see "Los Angeles"
    # Then I should not see "Berkeley"
    
    
# # @javascript    
# # Scenario: Having searched for more than 5 cities I should only see the last 5 ones displayed
# #     Given I go to the landing page
# #     And I visit multiple locations: Berkeley, Albany, Oakland, Richmond, San Jose, Los Angeles, Las Vegas,
# #     And I follow "Recent Searches"
# #     Then I should not see "Berkeley"
# #     Then I should not see "Albany"
# #     Then I should see "Oakland"
# #     Then I should see "Richmond"
# #     Then I should see "San Jose"
# #     Then I should see "Los Angeles"
# #     Then I should see "Las Vegas"

# # @javascript   
# # Scenario: Having searched for more than 5 cities I should only see the last 5 ones displayed
# #     Given I as "client1" have searched for "Berkeley"
# #     And I as "client1" have searched for "Albany"
# #     And I as "client1" have searched for "Oakland"
# #     And I as "client1" have searched for "Richmond"
# #     And I as "client1" have searched for "San Francisco"
# #     And I as "client1" have searched for "San Jose"
# #     And I am on the landing page
# #     Then I should see "San Jose"
# #     And I should see "San Francisco"
# #     And I should see "Richmond"
# #     And I should see "Oakland"
# #     And I should see "Albany"
# #     And I should not see "Berkeley"

