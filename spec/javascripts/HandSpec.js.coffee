describe "Hand", ->
  beforeEach ->
    @hand = new Hand([new PlayingCard(4, "Spades"),
                        new PlayingCard(5, "Hearts"),
                        new PlayingCard(4, "Diamonds"),
                        new PlayingCard(4, "Clubs")], yes)
  it "creates a set of card images with front-facing cards", ->
    expect(@hand.cardImages[0].src).toMatch(/s4.png/)

  it "creates back-facing cards when specified", ->
    backFacingHand = new Hand([new PlayingCard(4, "Spades"),
                        new PlayingCard(5, "Hearts"),
                        new PlayingCard(4, "Diamonds"),
                        new PlayingCard(4, "Clubs")], no)
    expect(backFacingHand.cardImages[0].src).toMatch(/backs_blue.png/)
    backFacingHand = new Hand([new PlayingCard(4, "Spades"),
                        new PlayingCard(5, "Hearts"),
                        new PlayingCard(4, "Diamonds"),
                        new PlayingCard(4, "Clubs")], no, 'red')
    expect(backFacingHand.cardImages[0].src).toMatch(/backs_red.png/)
