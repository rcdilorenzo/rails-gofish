Feature: Creating a User

  Scenario: Create existing user with name
      When I create an existing user with the name "Christian"
      Then I should see the user page for "Christian" with statistics

  Scenario: Create new user with name
      When I create a new user as "Christian"
      Then I should see the welcome page for "Christian" without statistics

