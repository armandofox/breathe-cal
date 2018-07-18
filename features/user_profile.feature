Feature: User Profile
    As an allergy sufferer, 
    in order to personalize my experience with the application,  
    I should be able to see and modify my user profile.
    
Background:
    Given I successfully authenticated with Google as "James Jones"
    And I am on the landing page

#PIVOTAL ID 152021342
@omniauth_google_login @user_profile
Scenario: Link to profile shown to logged in users
    Then I should see "James Jones"

#PIVOTAL ID 152021342
@omniauth_google_login @user_profile
Scenario: Logged in user can visit his profile page and see info
    When I follow "James Jones"
    Then I should see "James Jones"
    Then I should see "test@xxxx.com"

#PIVOTAL ID 152021342
@omniauth_google_login @user_profile   
Scenario: Gan go from profile page to homepage
    When I follow "James Jones"
    Then I should see "Back to Home Page"
    When I follow "Back to Home Page"
    Then I should be on the landing page

#PIVOTAL ID 152021342
@omniauth_google_login @user_profile     
Scenario: User tries to access someone else's profile
    When I go to another persons profile page
    Then I should be on the landing page
    And I should see "Cannot View Profile: Invalid UID"

#PIVOTAL ID 152021342
@omniauth_google_login @user_profile
Scenario: Non logged in user cannot see link to profile page
    Given I follow "Sign Out"
    Then I should not see "James Jones"

#PIVOTAL ID 152021342
@omniauth_google_login @user_profile
Scenario: Error displayed when non logged in user tries to access profile
    Given I follow "Sign Out"
    When I go to another persons profile page
    Then I should be on the landing page
    And I should see "Cannot View Profile: Not Signed In"
  