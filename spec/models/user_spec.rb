require 'spec_helper'

describe User do
  subject {FactoryGirl.build(:user)}
  its(:name) {should_not be_nil}
  its(:games) {should_not be_nil}

  context "with existing games" do
    let(:game1) { FactoryGirl.create(:game)  }
    before(:each) do
      subject.results.build(:game => game1)
    end
    its(:games) { should_not be_empty }
    its(:games) {should include game1}
    its(:name) {should == game1.players.first.name}
  end

  it "should throw error for non-alpha name" do
    lambda {FactoryGirl.create(:user, :name => "234kj6").save!}.should raise_error
  end

end
