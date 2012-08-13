Feature: Creating a User
  Background: Create a user
    Given I create a new user

  Scenario: Create existing user
    # Given I see a user page for "John" with statistics
    Then I should be able to start a game

  Scenario: Signing out
    When I sign out
    Then I should see a signed out message

  Scenario: Signing in
    # I have to sign out because sign in automatically ocurrs after signing up
    When I sign in after signing out
    Then I should see a signed in message

  # Scenario: Create existing user with name
  #     When I finish a game and win
  #     Then I should see the user page for "Christian" with statistics

  # Scenario: Create new user with name
  #     When I create a new user as "Christian"
  #     Then I should see the welcome page for "Christian" without statistics

