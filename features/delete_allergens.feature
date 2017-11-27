#  Feature:
#   As an allergy sufferer, in order to know the allergen information for
#   my location, I should be able to delete allergens from the map.
  
# Background: # (FAILS)
#   Given I am on the landing page
#   And I add a dog allergen

#Select an allergen and be able to delete it (FAILS)
# Scenario: Once an allergen has been created, I should be able to delete it
#   Given I click on the map
#   And I should view the create allergen box
#   And I fill in title with cat
#   And I check cat
#   And I press submit
#   When I press on the allergen
#   And I press delete
#   Then I should not see the allergen on the map