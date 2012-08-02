require 'spec_helper'

describe GameResult do
  subject {FactoryGirl.build(:game_result)}
  # subject {FactoryGirl.build(:user => User.create(:name => 'fred'), :game => GoFishGame.new)}
  its(:user) {should_not be_nil}
  its (:game) {should be_a_kind_of GoFishGame}

  it "should throw error if GameResult is created without a game" do
    lambda {GameResult.new.save!}.should raise_error
  end
  pending "finish testing and creating validations"
end
