require 'spec_helper'

describe GameResult do
  subject {FactoryGirl.build(:game_result)}
  # subject {FactoryGirl.build(:user => User.create(:name => 'fred'), :game => GoFishGame.new)}
  its(:user) {should_not be_nil}
  its(:game) {should be_a_kind_of GoFishGame}

  it "should throw error if GameResult is created without a game" do
    lambda {GameResult.new.save!}.should raise_error
  end

  context "when game has ended" do
    it "should throw an error if certain fields are not filled in" do
      subject { FactoryGirl.create(:ended_game_with_single_winner) }
      a_game_result = GameResult.new
      a_game_result.game = subject
      lambda { a_game_result.save! }.should raise_error
    end
    # it "should set all attributes and be validated if done correctly" do
    #   subject { FactoryGirl.create(:ended_game_result) }
    #   subject.user.name.should == "Christian"
    #   subject.game.should be_a_kind_of GoFishGame
    #   puts subject.game.players.first.books
    #   subject.game.winner.name.should == "Christian"
    #   lambda {subject.save!}.should_not raise_error

    #   # its(:player_scores) { should ==  }
    # end
  end
end
