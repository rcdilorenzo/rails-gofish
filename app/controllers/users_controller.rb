class UsersController < ApplicationController
  def new
  end

  def create
    new_user = true
    @user = User.find_by_name(params[:user][:name])
    if @user
      new_user = false
    else
      @user = User.new
      @user.name = params[:user][:name]
      @user.save!
    end
    Rails.cache.write(:new_user?, new_user)
    redirect_to user_url(:id => @user.id) 
  end

  def index
  end

  def show
    @user = User.find(params[:id])
    @games_played = @user.results.count

    user_stats = determine_stats(@user)
    @wins = user_stats[:wins]
    @losses = user_stats[:losses]
    @ties = user_stats[:ties]
    @games_played = user_stats[:games_played]
    @new_player = Rails.cache.read(:new_user?)
  end

  def determine_stats(user)
    @wins = 0
    @losses = 0
    @ties = 0
    @games_played = 0
    @user.results.map(&:game).each do |game|
      if game.end?
        if game.winner.is_a? GoFishPlayer
          @wins += 1 if game.winner.include?(game.players.first)
          @losses += 1 if !game.winner.include?(game.players.first)
        else
          @ties += 1 if game.winner.include?(game.players.first)
          @losses += 1 if !game.winner.include?(game.players.first)
        end
        @games_played += 1
      end
    end
    return {:wins => @wins, :losses => @losses, :ties => @ties, :games_played => @games_played}
  end

end
