Feature: Configuring credits based on chargify's products
  In order to set manage credits
  As a admin
  I should be able to setup credits per chargify product

  Background:
    Given I am signed up and confirmed as admin "jhon.doe@gmail.com/default"
    And I sign in as "jhon.doe@gmail.com/default"

  Scenario: Set credits values to corresponding products
    Given I go to my dashboard
    When I follow "Manage Account Types"
    And I fill in "account_type_credits" with "15"
    And I press "Set"
    Then I should see "Account type was successfully"
    When I fill in "account_type_credits" with "20"
    And I press "Set"
    Then I should see "Account type was successfully"
