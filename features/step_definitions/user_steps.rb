# When /[create|identify] a\w{0,1}.(\w+)\s?user .*"(.*?)"$/ do |type, name|
#   if type == "existing"
#     2.times do |count| # if executed twice user will be an existing user
#       visit('/')
#       fill_in :first_name, :with => name
#       fill_in :last_name, :with => "Doe"
#       fill_in :email, :with => "user@example.com"
#       fill_in :screen_name, :with => "winnerjohn65"
#       fill_in :street, :with => "123 Maple Avenue"
#       fill_in :city, :with => "Raleigh"
#       fill_in :state, :with => "NC"
#       fill_in :zip, :with => "98101"
      
#       click_button 'Create User'
#     end
#   elsif type == "new"
#     visit('/')
#     fill_in :first_name, :with => name
#       fill_in :last_name, :with => "Doe"
#       fill_in :email, :with => "user@example.com"
#       fill_in :screen_name, :with => "winnerjohn65"
#       fill_in :street, :with => "123 Maple Avenue"
#       fill_in :city, :with => "Raleigh"
#       fill_in :state, :with => "NC"
#       fill_in :zip, :with => "98101"
#       click_button 'Create User'
#   end
#   @username = name
# end

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

#-----------------------------------------------------------------------------

When /^I create a new user$/ do
  visit('/users/sign_up')
  fill_in 'user[first_name]', :with => "John"
  fill_in 'user[last_name]', :with => "Doe"
  fill_in 'user[email]', :with => "user@example.com"
  fill_in 'user[screen_name]', :with => "winnerjohn65"
  fill_in 'user[password]', :with => "password"
  fill_in 'user[password_confirmation]', :with => "password"
  fill_in 'address[street]', :with => "123 Maple Avenue"
  fill_in 'address[city]', :with => "Raleigh"
  fill_in 'address[state]', :with => "NC"
  fill_in 'address[zip]', :with => "98101"
  click_button 'Create User'
end

When /^I sign in$/ do
  visit('/users/sign_in')
  fill_in 'user[email]', :with => "user@example.com"
  fill_in 'user[password]', :with => "password"
  click_on 'Sign in' # form submit button -- NOT NAVIGATION ELEMENT
end

Then /^I should be able to start a game$/ do
  page.status_code.should == 200
  page.body.should =~ /Create Game/i
end

When /^I sign out$/ do
  click_on 'Sign out'  
end

Then /^I should see a signed out message$/ do
  page.body.should =~ /signed out/i
end

Then /^I should see a signed in message$/ do
  page.body.should =~ /signed in/i
end
