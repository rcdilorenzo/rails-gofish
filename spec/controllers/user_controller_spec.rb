require 'spec_helper'

describe UsersController do

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :show, { :id => 1 } # always with be user with id = 1
      assigns(:user).should eq(user)
    end
  end
end
