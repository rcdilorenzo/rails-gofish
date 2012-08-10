class GoFishPlayer
  attr_reader :name, :cards, :books
  attr_accessor :decision

  def initialize(name, game)
    @name = name
    @game = game
    @cards = []
    @books = []
  end

	def get_top_card
		return @cards[0]
		@cards.delete_at(0)
	end

  def take_turn
    @game.game_messages_title = "#{self.name} asks #{@decision.first.name} for any #{@decision.last}\'s!"
    cards_returned = ask_player_for_cards(@decision.first, @decision.last) unless @game.end?
    cards_returned.each do |card|
      @game.game_messages << "#{@decision.first.name} gives #{self.name} a #{card.rank} of #{card.suit}" unless card.rank == "Ace"
      @game.game_messages << "#{@decision.first.name} gives #{self.name} an #{card.rank} of #{card.suit}" if card.rank == "Ace"
    end
    cards.each {|a_card| check_for_books_using_card(a_card.rank)}
    cards.sort! {|a, b| a.value <=> b.value}
    if cards_returned != []
      @game.current_player = self
    else
      @game.current_player = @decision.first
    end
  end

  def request_is_legal?(requested_player, requested_rank)
    return false if (cards.select {|card| card.rank == requested_rank} == []) || (requested_player == nil) || requested_player.name.upcase == name.upcase
    return true
  end
  
  def add_card(card)
    cards << generate_cards_from_shorthand_string(card).first
  end

  def cards=(array_of_cards)
    if array_of_cards[0].class == String
      array_of_cards = array_of_cards.join(' ') if array_of_cards.class == Array
      @cards = [] if !array_of_cards
      @cards = generate_cards_from_shorthand_string(array_of_cards) if array_of_cards != ""
    else
      @cards = array_of_cards
    end
  end

  def generate_cards_from_shorthand_string(shorthand_string)
    cards_for_creation = shorthand_string.scan(/(\w{1})-*_*(\w{1,})/)
    card_name_expansion = %w(Jack Queen King Ace Hearts Clubs Diamonds Spades)
    array_of_cards = []
    cards_for_creation.each do |card|
      expanded_rank_name = card_name_expansion.select { |full_name| card.first[0].upcase == full_name[0] }
      expanded_suit_name = card_name_expansion.select { |full_name| card.last[0].upcase == full_name[0] }
      card[0] = card[0].to_i
      card[0] = expanded_rank_name[0] unless expanded_rank_name == []
      card[1] = expanded_suit_name[0]
      array_of_cards << Card.new(card[0], card[1])
    end
    return array_of_cards
  end

  def ask_player_for_cards(player, card_rank)
    cards_requested = player.give_cards_of_rank(card_rank)
    if (cards_requested == [])
      go_fish
      @game.game_messages << "Go fish!" unless self == @game.players.first # REMOVE IF MULTIPLAYER!!!
    else
      cards_requested.each {|card_requested| cards << card_requested}
    end
    return cards_requested
  end

  def give_cards_of_rank(requested_rank)
    cards_to_be_given = cards.select {|my_card| my_card.rank == requested_rank}
    @cards -= cards_to_be_given
    return cards_to_be_given
  end

  def go_fish
    cards << card_from_deck = @game.deck_of_cards.get_top_card
  end

  def check_for_books_using_card(received_card)
    if (cards.count { |card| card.rank == received_card} == 4)
      cards_of_same_rank = cards.select {|card| card.rank == received_card}
      @game.game_messages << "#{self.name}: New Book!"
      books << cards_of_same_rank
      cards_of_same_rank.each {|card_of_same_rank| cards.delete(card_of_same_rank)}
    end
  end
end
