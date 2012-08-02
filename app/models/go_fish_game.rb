require 'go_fish_player'
require 'go_fish_card_deck'

class NumberOfPlayersError < StandardError
  def initialize(num_of_players)
    @num_of_players = num_of_players
    super()
  end
  def message
    "You specified #{@num_of_players} player(s), but only 2-6 players can be used."
  end
end

class GoFishGame
  attr_reader :players, :num_of_cards_per_book
  attr_accessor :deck_of_cards, :current_player
  def initialize(*player_names)
    if player_names.first.class == Array
      player_names = player_names.first
    end
    raise NumberOfPlayersError.new(player_names.size) if player_names.size < 2 || player_names.size > 6
    @players = []
    player_names.map do |player_name|
      player_in_loop = GoFishPlayer.new(player_name.scan(/(\w+)$/).first.first, self)
      @players << player_in_loop
    end
    @deck_of_cards = GoFishDeckOfCards.new
    # write test for what setup does and include setting the current player
  end

  def save!
  end

  def setup(cards_to_deal=5)
    cards_to_deal.times {@players.each {|player| player.cards << @deck_of_cards.get_top_card}}
  end

  def end?
    players_without_cards = @players.select {|player| player.cards == []}
    return (@deck_of_cards.has_no_cards?) || (players_without_cards != [])
  end

  def winner
    score_of_all_players = []
    @players.each {|player| score_of_all_players << player.books.size}
    winner = @players[score_of_all_players.index(score_of_all_players.max)]
    return winner if (score_of_all_players.count{|p| p == score_of_all_players.max} == 1)
    return winner = "TIE"
  end

  private
  def robot_request_card
    Proc.new do |current_game, current_player|
      opponents = current_game.players.reject {|player| player == current_player}
      chosen_opponent = opponents.sample
      chosen_rank = current_player.cards.group_by(&:rank).sort_by{|a,b| b.size<=>a.size}.last[0]
      puts "#{current_player.name} has asked #{chosen_opponent.name} for any #{chosen_rank}\'s"
      decision = [chosen_opponent, chosen_rank]
    end
  end

  def live_player_request_card
    Proc.new do |current_game, current_player|
      puts "Please Request a Card: (e.g. Ask Christian for any 3\'s)"
      decision = gets.chomp
      decision = decision.scan(/\w*\s*(\w+) for any (\w+)'s/).first
      decision[0] = current_game.players.detect {|player| player.name.upcase == decision[0].upcase}
      decision[1] = decision[1].to_i if %w(JACK QUEEN KING ACE).select {|face_card| face_card == decision[1].upcase} == []
      decision
    end
  end
end
