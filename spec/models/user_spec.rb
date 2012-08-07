require 'spec_helper'

describe User do
  subject {FactoryGirl.build(:user)}
  its(:name) {should_not be_nil}
  its(:results) {should_not be_nil}

  context "with existing results" do
    let(:game1) { FactoryGirl.create(:game)  }
    before(:each) do
      subject.results.build(:game => game1)
    end
    its(:results) { should_not be_empty }
    its(:results) { should have(1).things }
    its(:name) {should == game1.players.first.name}
  end

  it "should throw error for non-alpha name" do
    lambda {FactoryGirl.create(:user, :name => "234kj6").save!}.should raise_error
  end

end
