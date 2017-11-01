Feature: Spare the Air Alert System  
  As an allergy sufferer 
  in order to receive emergency alert notifications for the Bay Area    
  I should see an alert box at the top of the application's home page 

@javascript   
Scenario: I should see alerts for San Francisco
    Given I am on the landing page
    Then I should see "Today's Air Alerts for the San Francisco Bay Area:"
    And I should see "No Alert" or "Alert In Effect"