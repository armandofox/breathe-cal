Feature: authentication
    As an allergy sufferer
    in order to personalize my experience with the application, 
    I should be able to create/sign-in to my personal account

# '@omniauth_google_login' set in /breathe-cal/features/support/hooks.rb

@omniauth_google_login
Scenario: See option to login with Google
  Given I am on the landing page
  Then I should see "Sign in with Google+"

@omniauth_google_login 
Scenario: Login with Google
  Given I successfully authenticated with Google as "James Jones"
  Then I should be on the landing page
  And I should see "James Jones"
  And I should not see "Some Guy"
  And I should not see "Sign in with Google+"
  And I should see "Sign Out"

@omniauth_google_login 
Scenario: Logout
  Given I successfully authenticated with Google as "James Jones"
  And I am on the landing page
  When I follow "Sign Out"
  Then I should be on the landing page
  And I should not see "James Jones"
  And I should see "Sign in with Google+"

@omniauth_google_login
Scenario: Login Failure
  Given I fail to login
  Then I should be on the landing page
  And I should see "Invalid_Credentials"
  And I should see "Sign in with Google+"
  

  

  
