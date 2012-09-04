class GamesController < ApplicationController
  before_filter :authenticate_user!

  def create
    render :check_for_javascript
  end

  def check_javascript
    if params[:js] == "true"
      redirect_to "/#{current_user.screen_name.downcase.gsub(/\s+/,'-').gsub(/[^a-z0-9_-]/,'').squeeze('-')}/games/new"
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
    @name = current_user.screen_name
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
    @game_result = GameResult.find(params[:id]) if params[:id]
    @game_result = current_user.results.build(:game => parse_YAML_JS_game(params[:game])) if params[:game]

    @game_result.game.players.each do |player|
      @game_result.player_scores.build(:score => player.books.size, :player_index => @game_result.game.players.index(player))
    end
    @game_result.winner = @game_result.game.winner
    @game_result.save!
    render :end
  end

  def parse_YAML_JS_game(game_in_YAML)
    game_to_be_parsed = YAML::load(game_in_YAML)
    parsedGame = GoFishGame.new(game_to_be_parsed["players"]["0"]["name"],
                                game_to_be_parsed["players"]["1"]["name"],
                                game_to_be_parsed["players"]["2"]["name"],
                                game_to_be_parsed["players"]["3"]["name"])
    parsedGame.deck_of_cards.cards = game_to_be_parsed["deck"]["cards"]
    4.times do |count|
      # Parse Cards
      player_cards = []
      game_to_be_parsed["players"]["#{count}"]["cards"][0..-2].each do |card|
        player_cards << Card.new(card["_rank"], card["_suit"])
      end
      parsedGame.players[count].cards = player_cards

      # Parse Books
      player_books = []
      (game_to_be_parsed["players"]["#{count}"]["books"].size/4).times do |book_count|
        book = []
        game_to_be_parsed["players"]["#{count}"]["books"][(0+(4*book_count))..(3+(4*book_count))].each do |card|
          book << Card.new(card["_rank"], card["_suit"])
        end
        player_books << book
      end
      parsedGame.players[count].books = player_books
    end
    return parsedGame
  end

  def robot_request_card(current_game, current_player)
    opponents = current_game.players.reject {|player| player == current_player}
    chosen_opponent = opponents.sample
    chosen_rank = current_player.cards.group_by(&:rank).sort_by{|a,b| b.size<=>a.size}.last[0]
    decision = [chosen_opponent, chosen_rank]
  end

end
