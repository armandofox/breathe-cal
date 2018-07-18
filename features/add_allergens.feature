 Feature:
  As an allergy sufferer, in order to know the allergen information for
  my location, I should be able to add allergens to the map.
  
Background: # (MANUAL PASS)
  Given I am on the landing page
  And I click click here to add an allergen
  
#PIVOTAL ID 152021104
#Click on the map and see the box to create an allergen (MANUAL PASS)
# Scenario: Once I've loaded the app, I should be able to begin creating an allergen
#   When I click on the map
#   Then I should view the create allergen box
  
#PIVOTAL ID 152021104
#SAD PATH: Click outside the map, and don't see the box to create an allergen (MANUAL PASS)
# Scenario: Once I've loaded the app, I should not be able to click outside the map and create an allergen
#   When I click on the green area of the sidebar
#   Then I should not view the create allergen box

#PIVOTAL ID 152021104
#Be able to fully add an allergen (MANUAL PASS)
# Scenario: Once the create allergen box is up, I should be able to add an allergen
#   Given I click on the map
#   And I should view the create allergen box
#   When I fill in title with cat
#   And I check cat
#   And I press submit
#   Then I should see the allergen on the map
  
#PIVOTAL ID 152021104
#Login and add an allergen, logout, login and have it still be there (MANUAL PASS)
# @omniauth_google_login
# Scenario: Once I login and add an allergen, that allergen should still be there if I log out/switch users
#   Given I add a dog allergen
#   And I successfully authenticated with Google as "James Jones"
#   Then I should see the allergen on the map
#   Given I follow "Sign Out"
#   Then I should see the allergen on the map

#PIVOTAL ID 152021104
#SAD PATH: Begin to make marker, fill in fields, exit. Should not see marker (MANUAL PASS)
# Scenario: Once I begin to add an allergen and exit before submitting, I should not see the allergen on the map
#   Given I click on the map
#   And I should view the create allergen box
#   And I fill in title with cat
#   And I check cat
#   When I exit the create allergen box
#   Then I should not see the allergen on the map
  
# PIVOTAL ID 152774026
# Add allergen and move the map (MANUAL PASS)
# Scenario: Once I add an allergen, I should be able to drag the map and still see it  
#   Given I add a dog allergen
#   And I click the map
#   And I drag the map
#   Then I should see the allergen on the map
  
# PIVOTAL ID 152774026 
# Add allergen and search a location using autocomplete (MANUAL PASS)
# Scenario: Once I add an allergen, I should be able to use the search bar and still see my added allergens
#   Given I add a dog allergen
#   And I search for 'Berkeley'
#   And I click on the first autofill response
#   Then I should see the allergen on the map