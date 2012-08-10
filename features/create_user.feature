Feature: Creating a User

  Scenario: Create existing user
    When I create a new user
    Then I sign out
    And I sign in
    Then I should be able to start a game

  Scenario: Signing out
    When I create a new user
    And I sign out
    Then I should see a signed out message

  Scenario: Signing in
    When I create a new user
    Then I sign out
    And I sign in
    Then I should see a signed in message

  # Scenario: Create existing user with name
  #     When I identify an existing user with the first name "John"
  #     Then I should see the user page for "Christian" with statistics

  # Scenario: Create new user with name
  #     When I create a new user as "Christian"
  #     Then I should see the welcome page for "Christian" without statistics

