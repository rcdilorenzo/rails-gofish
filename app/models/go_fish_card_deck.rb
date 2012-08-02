class Card
	attr_reader :rank, :suit, :value
	def initialize(rank, suit, *value)
		@rank = rank
		@suit = suit
		@value = value[0] if value != nil
	end

	def == other
		return super == other unless other.class == self.class
		rank == other.rank && suit == other.suit
	end

  def self.create_hand(cards)
    cards_for_creation = cards.scan(/(\w{1})-*_*(\w{1,})/)
    card_name_expansion = %w(Jack Queen King Ace Hearts Clubs Diamonds Spades)
    hand = []
    cards_for_creation.each do |card|
      expanded_rank_name = card_name_expansion.select { |full_name| card.first[0].upcase == full_name[0] }
      expanded_suit_name = card_name_expansion.select { |full_name| card.last[0].upcase == full_name[0] }
      card[0] = card[0].to_i
      card[0] = expanded_rank_name[0] unless expanded_rank_name == []
      card[1] = expanded_suit_name[0]
      hand << self.new(card[0], card[1])
    end
    return hand
  end

  def eql?(other)
    return super.eql?(other) unless other.class == Card
    [rank, suit] == [other.rank, other.suit]
  end

  def == other
    eql?(other)
	end

  def hash
    (rank.to_s+suit).hash
  end
end

class GoFishDeckOfCards
	attr_accessor :cards
	def initialize(cards=[])
		rank = [2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King", "Ace"]
		suit = ["Clubs", "Diamonds", "Spades", "Hearts"]
		@cards = cards
		value = 2
    if cards == []
      rank.each do |rank|
        suit.each {|suit| @cards << Card.new(rank, suit, value) }
        value += 1
      end
      @cards.shuffle!
    end
	end

  def has_no_cards?
    return @cards == []
  end
  
  def get_top_card
    @cards.shift
  end
end

