class UsersController < ApplicationController
  def new
    @user = User.new
    @user.addresses << Address.new
  end

  def create
    if params[:commit] == "Sign In"

      @user = User.find_by_first_name(params[:user][:first_name])
      if !@user
        flash.alert = "Invalid username and/or password." if params[:commit] == "Sign In"
        redirect_to('/') and return
      end
    elsif params[:commit] == "Create User"
      @user = User.new(params[:user])
      @user.password = params[:form][:password]
      @user.addresses.build(params[:address])
      @user.save
      if !@user.update_attributes(params[:user])
        flash.alert = "All fields are required." if params[:commit] == "Create User"
        redirect_to('/') and return
      end
    end
    redirect_to user_url(:id => @user.id) 
  end

  def index
  end

  def show
    @user = User.find(params[:id])
    @games_played = @user.results.count

    @wins = @user.wins
    @losses = @user.losses
    @ties = @user.ties
    @games_played = @user.games_played
    # test that determine_stats under user model works
  end


end
