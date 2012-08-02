require 'spec_helper'

describe GameResult do
  subject {FactoryGirl.build(:game_result)}
  # subject {FactoryGirl.build(:user => User.create(:name => 'fred'), :game => GoFishGame.new)}
  its(:user) {should_not be_nil}
  its (:game) {should be_a_kind_of GoFishGame}
end
