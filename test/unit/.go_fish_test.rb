require 'test/unit'
require 'test_helper'
require 'go_fish_game'
# require_relative '../../deckOfCards'
# require_relative '../go_fish_ui_game'

class GoFishGameTest < ActiveSupport::TestCase
  def setup
    @game = GoFishGame.new("Robot Player1", "Robot Player2")
    @player1 = @game.players[0]
    @player2 = @game.players[1]
  end

  def test_game_creation
    assert_equal(@game.players.size, 2)
    assert_not_nil(@game)
    player_names = @game.players.collect{|player| player.name}
    assert_equal(["Player1", "Player2"], player_names)
    assert_equal(GoFishPlayer, @game.players.first.class)
    assert_equal(GoFishDeckOfCards, @game.deck_of_cards.class)
  end

  def test_game_setup
     @game.setup
     assert_equal(@game.players.first.cards.first.class, Card)
     assert_equal(@game.players[1].cards.size, 5)
     assert_equal(@game.deck_of_cards.cards.size, 42)
  end

  def test_game_error
    assert_raise NumberOfPlayersError do
      my_game = GoFishGame.new("Player1")
    end
    assert_raise NumberOfPlayersError do
      my_game = GoFishGame.new("Player1", "Player2", "Player3", "Player4", "Player5", "Player6", "Player7")
    end
  end

  def test_communication_for_card_from_another_player_with_success
    assert_equal(@player1.cards.size, 0)
    assert_equal(@player2.cards.size, 0)
    @player1.cards << Card.new(2, "Hearts")
    @player2.cards << Card.new(2, "Clubs")
    @player1.ask_player_for_cards(@player2, 2)
    assert_equal(@player1.cards.size, 2)
    assert_equal(@player1.cards.first.suit, "Hearts")
    assert_equal(@player1.cards.last.suit, "Clubs")
  end

  def test_communication_for_card_from_another_player_without_success
    @player1.cards << Card.new(2, "Hearts")
    @player2.cards << Card.new(3, "Clubs")
    @player2.ask_player_for_cards(@player1, 3)
    assert_equal(@game.deck_of_cards.cards.size, 51)
    assert_equal(@player2.cards.size, 2)
  end

  def test_book_creation
    @player1.cards << Card.new(4, "Hearts")
    @player1.cards << Card.new(4, "Clubs")
    @player1.cards << Card.new(4, "Diamonds")
    @player2.cards << Card.new(4, "Spades")
    @player1.ask_player_for_cards(@player2, 4)
    @player1.cards.each {|a_card| @player1.check_for_books_using_card(a_card.rank)}
    assert_equal(@player1.cards.size, 0)
  end

  def test_round_with_full_deck
    @game.setup
    @game.players.first.decision = robot_request(@game, @game.players.first)
    @game.players.first.take_turn
    assert(@game.players.first.cards.size >= 6)
  end

  def test_end_conditions
    @game.setup
    assert_not_nil(@game.end?)
    count = 0
    while @game.end? == false do
      count += 1
      @game.players.first.cards = [] if count == 8
      @game.players.each { |player| puts "#{player.name} has #{player.cards.size} cards." }
      @game.end?
    end
    assert_equal(count, 8)
    
    @game.setup
    count = 1
    while @game.end? == false do
      @game.players.each do |player|
        player.decision = robot_request(@game, player)
        player.take_turn
      end
      count += 1
      @game.deck_of_cards.cards = [] if count == 4
    end
    assert_equal(count, 4)
  end

  def robot_request(current_game, current_player)
    opponents = current_game.players.reject {|player| player == current_player}
    chosen_opponent = opponents.sample
    chosen_rank = current_player.cards.group_by(&:rank).sort_by{|a,b| b.size<=>a.size}.last[0]
    decision = [chosen_opponent, chosen_rank]
  end

  # def test_game_scoring
  #   complete_game = GoFishGame.new("Robot Player1", "Robot Player2", "Robot Player3", "Robot Player4")
  #   # puts "Game started."
  #   def calculated_winner_index(game)
  #     players_scores = []
  #     game.players.each {|p| players_scores << p.books.size}
  #     players_scores.sort!
  #     return players_scores.max
  #   end
  #   if complete_game.winner.class == GoFishPlayer
  #     assert_equal(complete_game.winner.books.size, calculated_winner_index(complete_game))
  #     puts "#{complete_game.winner.name} wins with #{complete_game.winner.books.size} books!"
  #   else
  #     assert_equal(complete_game.winner, "TIE")
  #     puts complete_game.winner
  #   end
  # end

  def test_regexp_for_card_creation
    @player1.cards = Card.create_hand("AH 3_Clubs Jd q-c 4-spades")
    assert_equal(@player1.cards.size, 5)
    assert_equal(@player1.cards[0].rank, "Ace")
    assert_equal(@player1.cards[0].suit, "Hearts")
    assert_equal(@player1.cards[1].rank, 3)
    assert_equal(@player1.cards[1].suit, "Clubs")
    assert_equal(@player1.cards[2].rank, "Jack")
    assert_equal(@player1.cards[2].suit, "Diamonds")
    assert_equal(@player1.cards[3].rank, "Queen")
    assert_equal(@player1.cards[3].suit, "Clubs")
    assert_equal(@player1.cards[4].rank, 4)
    assert_equal(@player1.cards[4].suit, "Spades")
    @player2.add_card("AH")
    @player2.add_card("4_hearts")
    @player2.add_card("Qs")
    @player2.add_card("4-d")
    @player2.add_card("k-clubs")
    assert_equal(@player2.cards.size, 5)
    assert_equal(@player2.cards[0].rank, "Ace")
    assert_equal(@player2.cards[0].suit, "Hearts")
    assert_equal(@player2.cards[1].rank, 4)
    assert_equal(@player2.cards[1].suit, "Hearts")
    assert_equal(@player2.cards[2].rank, "Queen")
    assert_equal(@player2.cards[2].suit, "Spades")
    assert_equal(@player2.cards[3].rank, 4)
    assert_equal(@player2.cards[3].suit, "Diamonds")
    assert_equal(@player2.cards[4].rank, "King")
    assert_equal(@player2.cards[4].suit, "Clubs")
    @player1.cards = []
    @player1.cards = %w(AH 3_Clubs Jd q-c 4-spades)
    assert_equal(@player1.cards.size, 5)
    assert_equal(@player1.cards[0].rank, "Ace")
    assert_equal(@player1.cards[0].suit, "Hearts")
    assert_equal(@player1.cards[1].rank, 3)
    assert_equal(@player1.cards[1].suit, "Clubs")
    assert_equal(@player1.cards[2].rank, "Jack")
    assert_equal(@player1.cards[2].suit, "Diamonds")
    assert_equal(@player1.cards[3].rank, "Queen")
    assert_equal(@player1.cards[3].suit, "Clubs")
    assert_equal(@player1.cards[4].rank, 4)
    assert_equal(@player1.cards[4].suit, "Spades")
  end

  def test_card_hashes
    ace_spades_1 = Card.new('A', 'Spades')
    ace_spades_2 = Card.new('A', 'Spades')
    hash = {ace_spades_1 => 'WILD'}
    assert(ace_spades_1 == ace_spades_2)
    assert_equal(ace_spades_1, ace_spades_2)
    assert_equal('WILD', hash[ace_spades_2])
  end
end
