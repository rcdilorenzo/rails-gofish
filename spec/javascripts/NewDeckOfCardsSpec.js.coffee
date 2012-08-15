describe "Deck of Cards", ->
  beforeEach -> @deck = new DeckOfCards()

  it "contains 52 cards", ->
    expect(@deck.numberOfCards()).toBe(52)

  describe "draw", ->
    it "should return a card and remove it from the deck", ->
      card = @deck.draw()
      expect(card instanceof PlayingCard).toBe(true)
      expect(@deck.numberOfCards()).toBe(51)

    it "should return a card with a rank and suit", ->
      card = @deck.draw()
      expect(card.rank()).not.toBe(null)
      expect(card.suit()).not.toBe(null)

  describe "hasCards", ->
    it "should be true if the deck has cards", ->
      deck = new DeckOfCards()
      expect(deck.hasCards()).toBe(true)
    
    it "should be false if the deck is empty", ->
      @deck.cards = []
      expect(@deck.numberOfCards()).toBe(0)
      expect(@deck.hasCards()).toBe(false)
