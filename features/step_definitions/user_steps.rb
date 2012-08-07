When /create a\w{0,1}.(\w+)\s?user .*"(.*?)"$/ do |type, name|
  if type == "existing"
    2.times do |count| # if executed twice user will be an existing user
      visit('/')
      fill_in :name, :with => name
      click_button 'Start'
    end
  elsif type == "new"
    visit('/')
    fill_in :name, :with => name
    click_button 'Start'
  end
  @username = name
end

Then /see.*[welcome|user].*"(.*)".?(\w+).*stat.*s/ do |name, statistics|
  if statistics == "with"
    page.should_not have_xpath('//*', :text => /Christian.*don't.*stat.*play.*game/i)
    page.should have_xpath('//*', :text => /.*(welcome|again|back).*(Christian)/i)
  elsif statistics == "without"
    page.should_not have_xpath('//*', :text => /.*(welcome|again|back).*(Christian)/i)
    page.should have_xpath('//*', :text => /Christian.*don't.*stat.*play.*game/i)
  end
end

When /win.{0,6}game|won.*game|finish.*game.*win|I\swin|game.*win/ do
  user = User.find_by_name(@username)
  puts user
  
  game_result = FactoryGirl.create(:game_result)
end

Then /^I should.*(\d)\swins?.(\d)\slosse?s?.(\d)\sties?.+(\d)\sgames?/ do |wins, losses, ties, games|
  pending # express the regexp above with the code you wish you had
end
