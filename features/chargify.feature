Feature: Chargify integration
  In order integrate use chargify recurring billing
  As a user
  I should be able to use chargify

  Background:
    Given I am signed up and confirmed as user "jhon.doe@gmail.com/default"
    And I sign in as "jhon.doe@gmail.com/default"

  Scenario: Accesing my account settings
    Given I have the following organizations
    | name            |
    | My Organization |
    And I go to my dashboard
    When I follow "My Organization" within "div#brand"
    And I follow "Account Settings"
    Then I should see "Account Admin" within "div.account_options"
    And I should see "Plans & Billing" within "div.account_options"
    And I should see "Payment History" within "div.account_options"
    And I should see "credits used / available"
    And I should see "Change Plan"

  # Scenario: Accesing plans & billing
  #   Given I have the following organizations
  #   | name            |
  #   | My Organization |
  #   And I go to my dashboard
  #   When I follow "My Organization" within "div#brand"
  #   And I follow "Account Settings"
  #   Then I should see "Account Admin" within "div.account_options"
  #   And I should see "Plans & Billing" within "div.account_options"
  #   And I should see "Payment History" within "div.account_options"
  #   And I should see "credits used / available"
  #   And I should see "Change Plan"
  # 
  # Scenario: Changing my plan
  #   Given I have the following organizations
  #   | name            |
  #   | My Organization |
  #   And I go to my dashboard
  #   When I follow "My Organization" within "div#brand"
  #   And I follow "Account Settings"
  #   Then I should see "Account Admin" within "div.account_options"
  #   And I should see "Plans & Billing" within "div.account_options"
  #   And I should see "Payment History" within "div.account_options"
  #   And I should see "credits used / available"
  #   And I should see "Change Plan"
