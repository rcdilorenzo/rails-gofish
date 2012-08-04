class GameController < ApplicationController
  def new
    @user = User.find_by_name(params[:name])
    
    current_game_result = GameResult.new

    user_result = @user.results.build(:game => GoFishGame.new(params[:name], "Rack", "Shack", "Benny"))
    @user.save!
    puts "Game Result on creation: #{@user.results}"
    redirect_to game_url(:id => user_result.id)
  end

  def show
    @game_result = GameResult.find(params[:id])
    @game = @game_result.game
    @game.setup
    @game.current_player = @game.players.first # live player will always be the first one
    
    if @game.end?
      redirect_to game_end_url(:id => params[:id])
    end
    @turn = (@game.current_player == @game.players.first)
    unless @turn
      @game.current_player.decision = robot_request_card(@game, @game.current_player)
      @game.current_player.take_turn
    end
    
    @game_result.game = @game
    @game_result.save!

    render :game and return
  end

  def play
    game_result = GameResult.find(params[:key])
    game = game_result.game

    game.current_player.decision = [params[:chosen_player], params[:chosen_rank]]
    current_player_decision = game.current_player.decision
    current_player_decision[0] = game.players.detect {|player| player.name.upcase == current_player_decision[0].upcase}
    current_player_decision[1] = current_player_decision[1].to_i if %w(JACK QUEEN KING ACE).select {|face_card| face_card == current_player_decision[1].upcase} == []

    @game.current_player.take_turn

    game_result.game = game
    game_result.save!

    if @game.end?
      redirect_to game_end_url(:id => params[:key])
    else
      redirect_to game_url(:id => params[:key])
    end
  end

end
