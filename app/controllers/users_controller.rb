class UsersController < ApplicationController
  def new
    @user = User.new
    @user.addresses << Address.new
  end

  before_filter :authenticate_user!, :except => :new

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
