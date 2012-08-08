class GamesController < ApplicationController
  def new
    redirect_to game_url(:id => params[:id])
  end

  def create
    @user = User.find(params[:id])
    
    user_result = @user.results.build(:game => GoFishGame.new(@user.screen_name, "Rack", "Shack", "Benny"))
    user_result.game.setup
    user_result.game.current_player = user_result.game.players.first # live player will always be the first one
    @user.save!
    redirect_to game_url(:id => user_result.id)
  end

  def show
    @game_result = GameResult.find(params[:id])
    @game = @game_result.game
    @game = YAML::load(@game) unless @game.class == GoFishGame
    
    if @game.end?
      redirect_to game_end_url(:id => params[:id]) and return
    end
    @turn = (@game.current_player == @game.players.first)
    unless @turn
      @game.current_player.decision = robot_request_card(@game, @game.current_player)
      @game.current_player.take_turn

    end
    
    @game_result.game = @game
    render :game
    @game_result.game.game_messages = []
    @game_result.game.game_messages_title = []
    @game_result.save!
  end

  def play
    game_result = GameResult.find(params[:key])
    game = game_result.game

    game.current_player.decision = [params[:chosen_player], params[:chosen_rank]]
    current_player_decision = game.current_player.decision
    current_player_decision[0] = game.players.detect {|player| player.name.upcase == current_player_decision[0].upcase}
    current_player_decision[1] = current_player_decision[1].to_i if %w(JACK QUEEN KING ACE).select {|face_card| face_card == current_player_decision[1].upcase} == []

    game.current_player.take_turn
    game_result.game = game
    game_result.save!

    if game.end?
      redirect_to game_end_url(:id => params[:key])
      game.game_messages = []
      game.game_messages_title = []
      return
    else
      game.game_messages = []
      redirect_to game_url(:id => params[:key])
      game.game_messages_title = []
      return
    end
  end

  def endgame
    @game_result = GameResult.find(params[:id])
    @game_result.game.players.each do |player|
      @game_result.player_scores.build(:score => player.books.size, :player_index => @game_result.game.players.index(player))
    end
    @game_result.winner = @game_result.game.winner
    render :end
  end

  def robot_request_card(current_game, current_player)
    opponents = current_game.players.reject {|player| player == current_player}
    chosen_opponent = opponents.sample
    chosen_rank = current_player.cards.group_by(&:rank).sort_by{|a,b| b.size<=>a.size}.last[0]
    decision = [chosen_opponent, chosen_rank]
  end

end
