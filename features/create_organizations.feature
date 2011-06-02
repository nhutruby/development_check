Feature: Creating Organizations
  In order manage organizations
  As a user
  I should be able to create organizations

  Background:
    Given I am signed up and confirmed as user "jhon.doe@gmail.com/default"
    And I sign in as "jhon.doe@gmail.com/default"

  Scenario: Create an organization
    Given I go to my dashboard
    When I follow "Add your Brand"
    And I fill in "organization_name" with "Green Light Group Tours"
    And I fill in "organization_description" with "Touring company"
    And I press "organization_submit"
    Then I should see "Brand: Green Light Group Tours"
