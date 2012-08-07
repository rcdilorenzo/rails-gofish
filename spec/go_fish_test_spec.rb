require 'spec_helper'

describe GoFishGame do
  before do
    @game = GoFishGame.new("Robot Player1", "Robot Player2")
    @player1 = @game.players[0]
    @player2 = @game.players[1]
  end

  context "2 Player Game" do
    it "creates a game with specified players" do
      @game.should be_a_kind_of GoFishGame
      @game.deck_of_cards.should be_a_kind_of GoFishDeckOfCards
      @game.players.size.should == 2
      @game.players.collect{|player| player.name}.should == ["Player1", "Player2"]
    end

    it "deals each player 5 cards" do
      @game.setup
      @game.players.first.cards.first.should be_a_kind_of Card
      @game.players[1].cards.size.should == 5
      @game.deck_of_cards.cards.size.should == 42
    end

    it "raises a NumberOfPlayersError if there are more/less than 2-6 players" do
      lambda {GoFishGame.new("Player1")}.should raise_error(NumberOfPlayersError)
      lambda {GoFishGame.new("Player1", "Player2", "Player3", "Player4", "Player5", "Player6", "Player7")}.should raise_error(NumberOfPlayersError)
    end

    it "can tell a player to start turn" do
      @game.setup
      player = @game.players.first
      player.decision = [@game.players.last, player.cards.first.rank]
      player.take_turn
      @game.players.first.cards.size.should >= 5
    end

    it "ends the game if the deck has no cards or if a player has only books and no cards" do
      @game.setup
      @game.end?.should_not == nil
      count = 1
      while @game.end? == false do
        @game.players.each do |player|
          opponents = @game.players.reject {|a_player| a_player == player}
          chosen_opponent = opponents.sample
          chosen_rank = player.cards.group_by(&:rank).sort_by{|a,b| b.size<=>a.size}.last[0]
          player.decision = [chosen_opponent, chosen_rank]
          player.take_turn
        end
        count += 1
        if count == 8
            @game.players.first.cards = []
            # break
        end
      end
      count.should == 8

      @game.setup
      count = 1
      while @game.end? == false do
        @game.players.each {|player| player.take_turn}
        count += 1
        @game.deck_of_cards.cards = [] if count == 4
      end
      count.should == 4
    end
  end

  context "4 Player Game" do
    it "returns a winner after the game is over" do
      complete_game = GoFishGame.new("Robot Player1", "Robot Player2", "Robot Player3", "Robot Player4")
      # puts "Game started."
      complete_game.setup
      while complete_game.end? == false
        complete_game.players.each do |player|
          opponents = @game.players.reject {|a_player| a_player == player}
          chosen_opponent = opponents.sample
          chosen_rank = player.cards.group_by(&:rank).sort_by{|a,b| b.size<=>a.size}.last[0]
          player.decision = [chosen_opponent, chosen_rank]
          player.take_turn
          break if complete_game.end?
        end
      end
      def calculated_winner_index(game)
        players_scores = []
        game.players.each {|p| players_scores << p.books.size}
        players_scores.sort!
        return players_scores.max
      end
      if complete_game.winner.class == GoFishPlayer
        complete_game.winner.books.size.should == calculated_winner_index(complete_game)
        # puts "#{complete_game.winner.name} wins with #{complete_game.winner.books.size} books!"
      else
        complete_game.winner.count.should > 1
        # puts complete_game.winner
      end
    end
  end
end

describe GoFishPlayer do
  before do
    @game = GoFishGame.new("Robot Player1", "Robot Player2")
    @player1 = @game.players[0]
    @player2 = @game.players[1]
  end

  context "Requesting Cards of Rank" do
    context "when other player has at least one card of specified rank" do
      it "transfers one player's card to another player" do
        @player1.cards << Card.new(2, "Hearts")
        @player2.cards << Card.new(2, "Clubs")
        @player1.ask_player_for_cards(@player2, 2)
        @player1.cards.size.should == 2
        @player1.cards.first.suit.should == "Hearts"
        @player1.cards.last.suit.should == "Clubs"
      end
    end

    context "when other player doesn\'t have any cards of specified rank" do
      it "does not transfer rank of card that doesn\'t exist" do
        @player1.add_card("2H")
        @player2.add_card("3C")
        @player1.ask_player_for_cards(@player2, 2) if @player1.request_is_legal?(@player2, 3)
        @player1.cards.size.should == 1
        @player1.cards.first.suit.should == "Hearts"
        @player2.cards.first.suit.should == "Clubs"
      end
    end
  end

  context "4 Cards of Same Rank in Player's Hand" do
    it "creates a book" do
      @player1.cards = %w(4h 4C 4D)
      @player2.add_card("4S")
      @player1.ask_player_for_cards(@player2, 4)
      @player1.cards.each {|a_card| @player1.check_for_books_using_card(a_card.rank)}
      @player1.cards.size.should == 0
      @player1.books.size.should == 1
    end
  end
end

describe Card do
  before do
    @game = GoFishGame.new("Robot Player1", "Robot Player2")
    @player1 = @game.players[0]
    @player2 = @game.players[1]
  end

  context "Creating a Card" do
    it "can use shorthand entry like \"AH\" or \"3-Spades\"" do
      @player1.cards = Card.create_hand("AH 3_Clubs Jd q-c 4-spades")
      @player1.cards.size.should == 5
      @player1.cards[0].rank.should == "Ace"
      @player1.cards[0].suit.should == "Hearts"
      @player1.cards[1].rank.should == 3
      @player1.cards[1].suit.should == "Clubs"
      @player1.cards[2].rank.should == "Jack"
      @player1.cards[2].suit.should == "Diamonds"
      @player1.cards[3].rank.should == "Queen"
      @player1.cards[3].suit.should == "Clubs"
      @player1.cards[4].rank.should == 4
      @player1.cards[4].suit.should == "Spades"

      @player2.add_card("AH")
      @player2.add_card("4_hearts")
      @player2.add_card("Qs")
      @player2.add_card("4-d")
      @player2.add_card("k-clubs")
      @player2.cards.size.should == 5
      @player2.cards[0].rank.should == "Ace"
      @player2.cards[0].suit.should == "Hearts"
      @player2.cards[1].rank.should == 4
      @player2.cards[1].suit.should == "Hearts"
      @player2.cards[2].rank.should == "Queen"
      @player2.cards[2].suit.should == "Spades"
      @player2.cards[3].rank.should == 4
      @player2.cards[3].suit.should == "Diamonds"
      @player2.cards[4].rank.should == "King"
      @player2.cards[4].suit.should == "Clubs"

      @player1.cards = []
      @player1.cards = %w(AH 3_Clubs Jd q-c 4-spades)
      @player1.cards.size.should == 5
      @player1.cards[0].rank.should == "Ace"
      @player1.cards[0].suit.should == "Hearts"
      @player1.cards[1].rank.should == 3
      @player1.cards[1].suit.should == "Clubs"
      @player1.cards[2].rank.should == "Jack"
      @player1.cards[2].suit.should == "Diamonds"
      @player1.cards[3].rank.should == "Queen"
      @player1.cards[3].suit.should == "Clubs"
      @player1.cards[4].rank.should == 4
      @player1.cards[4].suit.should == "Spades"
    end
  end

  context "Comparing Cards" do
    it "compares two cards based on their rank and suit" do
      ace_spades_1 = Card.new('A', 'Spades')
      ace_spades_2 = Card.new('A', 'Spades')
      hash = {ace_spades_1 => 'WILD'}
      ace_spades_1.should == ace_spades_2
      ace_spades_1.should == ace_spades_2
      hash[ace_spades_2].should == 'WILD'
    end 
  end
end

# describe PlayerUI do
#   context "when game has 2 computer players" do
#     it "collaborate with Player Object to only allow legal decisions for every turn" do
#     end
#   end

#   it "connects to the game which has reference back to it" do
#     @ui = GameUI.new
#     @game = GoFishGame.new("Robot John", "Robot Christian")
#     @game.ui = @ui
#     @ui.game = @game
#     @game.setup
#     while @game.end? == false
#       @game.players.each do |player|
#         opponents = @game.players.reject {|a_player| a_player == player}
#         chosen_opponent = opponents.sample
#         chosen_rank = player.cards.group_by(&:rank).sort_by{|a,b| b.size<=>a.size}.last[0]
#         player.decision = [chosen_opponent, chosen_rank]
#         player.take_turn
#         break if @game.end?
#       end
#     end
#     @ui.game.players.size.should == 2
#     @ui.should == @ui.game.ui
#   end

#   context "when game has 1 live player and 2 computer players" do
#     before(:each) do
#       @ui = GameUI.new
#       @game = GoFishGame.new("Robot John", "Ken", "Robot Christian")
#       @ui.game = @game
#       @game.ui = @ui
#       @game.deck_of_cards = GoFishDeckOfCards.new(Card.create_hand("2H 5C 3S 4D 5S 8H 8C 8S 8D AH"))
#       @game.setup(3) # Deal 3 cards to each player

#       live_player = @game.players[1]
#       live_player.ui = mock(PlayerUI)
#       live_player.ui.stub!(:request_card).and_return(live_player.decision = [@game.players[2], 8])

#       @returned_cards = []
#       @returned_cards_objects = []
#       live_player.ui.stub!(:print_card_returned) do |player, card|
#         @returned_cards << [player.name, card.rank, card.suit]
#         @returned_cards_objects << player
#         @returned_cards_objects << card
#         @game.players[1].cards << card
#       end
#       [:take_turn, :print_card_request_denied, :print_go_fish, :turn_end].each {|method| live_player.ui.stub!(method)}
#     end

#     subject {@game.players[1]}
    
#     it "asks player for his/her request to another player for a certain rank" do
#       subject.take_turn
#       subject.cards.last.should == Card.new(8, "Diamonds")
#       subject.cards.size.should == 7
#     end

#     it "only allows legal decisions" do
#       subject.take_turn
      # subject.request_is_legal?(@returned_cards_objects.first, @returned_cards_objects[1].rank).should == true
    # end
  # end
  
# end
