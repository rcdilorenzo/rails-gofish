class GamesController < ApplicationController
  before_filter :authenticate_user!

  def create
    render :check_for_javascript
  end

  def check_javascript
    if params[:js] == "true"
      redirect_to "/#{current_user.screen_name}/games/new"
    else
      @user = current_user
      user_result = @user.results.build(:game => GoFishGame.new(@user.screen_name, "Rack", "Shack", "Benny"))
      user_result.game.setup
      user_result.game.current_player = user_result.game.players.first # live player will always be the first one
      @user.save!
      redirect_to "/create_ruby_game/#{user_result.id}"
    end
  end

  def create_ruby_game
    @user = current_user
    user_result = @user.results.build(:game => GoFishGame.new(@user.screen_name, "Rack", "Shack", "Benny"))
    user_result.game.setup
    user_result.game.current_player = user_result.game.players.first # live player will always be the first one
    @user.save!
    redirect_to game_show_url(:id => user_result.id)
  end

  def show_js_game
    @name = params[:screen_name]
    ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']
    suits = ['Clubs', 'Diamonds', 'Hearts', 'Spades']
    @imgStrings = []
    for rank in ranks
      for suit in suits
        if rank.class == Fixnum
          @imgStrings.push("./../../assets/#{suit[0].downcase}#{rank}.png")
        else
          @imgStrings.push("./../../assets/#{suit[0].downcase}#{rank[0].downcase}.png")
        end
      end
    end
    @imgStrings.push("./../../assets/backs_blue.png")
    @imgStrings.push("./../../assets/backs_red.png")
    render :javascriptGame
  end

  def show_ruby_game
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
      redirect_to game_show_url(:id => params[:key])
      game.game_messages_title = []
      return
    end
  end

  def endgame
    if params[:id]
      @game_result = GameResult.find(params[:id])
      @game_result.game.players.each do |player|
        @game_result.player_scores.build(:score => player.books.size, :player_index => @game_result.game.players.index(player))
      end
      @game_result.winner = @game_result.game.winner
      render :end
    else
      @game_result = YAML::load(params[:game])
      puts params[:game]
      render :nothing
    end
  end

  def robot_request_card(current_game, current_player)
    opponents = current_game.players.reject {|player| player == current_player}
    chosen_opponent = opponents.sample
    chosen_rank = current_player.cards.group_by(&:rank).sort_by{|a,b| b.size<=>a.size}.last[0]
    decision = [chosen_opponent, chosen_rank]
  end

end
