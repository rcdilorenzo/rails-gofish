describe("Deck of Cards", function() {
  var deck;

  beforeEach(function() {
    deck = new DeckOfCards();
  })

  it("should contain 52 cards", function() {
    expect(deck.numberOfCards()).toBe(52);
  })

  describe("draw", function() {
    it("should return a card and remove it from the deck", function() {
      var card = deck.draw();
      console.log(card);
      expect(card instanceof PlayingCard).toBe(true);
      expect(deck.numberOfCards()).toBe(51);
    })
    it("should return a card with a rank and suit", function() {
      var card = deck.draw();
      expect(card.rank).not.toBe(null);
      expect(card.suit).not.toBe(null);
    })
  })

  describe("hasCards", function () {
    it("should be true if the deck has cards", function() {
      deck = new DeckOfCards();
      expect(deck.hasCards()).toBe(true);
    })
    it("should be false if the deck is empty", function() {
      for (i=0; i<52; i++) {
        deck.draw();
      }
      expect(deck.hasCards()).toBe(false);
    })
  })
});
