When /[create|identify] a\w{0,1}.(\w+)\s?user .*"(.*?)"$/ do |type, name|
  if type == "existing"
    2.times do |count| # if executed twice user will be an existing user
      visit('/')
      fill_in :first_name, :with => name
      fill_in :last_name, :with => "Doe"
      fill_in :email, :with => "user@example.com"
      fill_in :screen_name, :with => "winnerjohn65"
      fill_in :street, :with => "123 Maple Avenue"
      fill_in :city, :with => "Raleigh"
      fill_in :state, :with => "NC"
      fill_in :zip, :with => "98101"
      
      click_button 'Create User'
    end
  elsif type == "new"
    visit('/')
    fill_in :first_name, :with => name
      fill_in :last_name, :with => "Doe"
      fill_in :email, :with => "user@example.com"
      fill_in :screen_name, :with => "winnerjohn65"
      fill_in :street, :with => "123 Maple Avenue"
      fill_in :city, :with => "Raleigh"
      fill_in :state, :with => "NC"
      fill_in :zip, :with => "98101"
      click_button 'Create User'
  end
  @username = name
end

# Example: Then I should see the user page for "Christian" without statistics
# Example: Then I should see a welcome webpage for "Christian" with statistics
# Example: Then I should see a user "Christian" with stats
Then /see.*[welcome|user].*"(.*)".?(\w+).*stat.*s/ do |name, statistics|
  if statistics == "with"
    # "Welcome back, Christian"
    page.body.should_not =~ /Christian.*don't.*stat.*play.*game/i

    # Christian doesn't have any stats. You need to play a game.
    page.body.should =~ /.*(welcome|again|back).*(Christian)/i

  elsif statistics == "without"
    # "Welcome back, Christian"
    page.body.should_not =~ /.*(welcome|again|back).*(Christian)/i

    # Christian doesn't have any stats. You need to play a game.
    page.body.should =~ /Christian.*stat.*play.*game/i
  end
end

When /win.{0,6}game|won.*game|finish.*game.*win|I\swin|game.*win/ do
  # user = User.find_by_name(@username)
  # game_result = FactoryGirl.create(:game_result)
end

Then /^I should.*(\d)\swins?.(\d)\slosse?s?.(\d)\sties?.+(\d)\sgames?/ do |wins, losses, ties, games|
  pending # express the regexp above with the code you wish you had
end
