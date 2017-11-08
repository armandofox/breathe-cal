Feature: authentication
    As an allergy sufferer
    in order to personalize my experience with the application, 
    I should be able to create/sign-in to my personal account

Background: 
  Given We skip this scenario: PLEASE IMPLEMENT ME

Scenario: I should see a google plus sign-in icon on the landing page
  Given I am on the landing page
  Then I should see the text on the side "Sign in with Google+"

Scenario: If I click on the google plus icon I should  
  Given we shall skip this test because Capybara cannot access HTTP resources outside the rack application
  # Given I am on the landing page
  # When I follow "Sign in with Google+"
  # Then I should be taken to the google authentication page
  
Scenario: If I input invalid google credentials I should be taken to the homepage with an error message
  Given I skip this and save it for later

Scenario: If I input legitimate google credentials I should be taken to the homepage as a user
  Given I successfully authenticated with Google as "James Jones"
  Then I should be on the landing page
  And I should see the text on the side "James Jones"
  And I should not see "Some Guy"
  And I should see the button "Sign Out"
  
Scenario: As a logged in user I should be able to logout when I press the sign out link
  Given I am logged in as "James Jones"
  And I am on the landing page
  When I follow "Sign Out"
  Then I should be on the landing page
  And I should not see "James Jones"
  And I should see the text on the side "Sign in with Google+"
  

  
