describe "Live Player Hand", ->
  beforeEach ->
    myPlayer = new Player("John")
    myPlayer.cards = [new PlayingCard(4, "Spades"), new PlayingCard(5, "Hearts"), new PlayingCard(4, "Diamonds"), new PlayingCard(4, "Clubs")]

    spyOn(LivePlayerHand.prototype, 'getImage').andReturn('Test Card Object')
    @hand = new LivePlayerHand(myPlayer, 330, 600)

  it "inherits from Hand", ->
    # check if a parent's method exists
    expect(@hand.drawName).not.toBe(undefined)

  it "is drawn at specified point", ->
    expect(@hand.x).toBe(330)
    expect(@hand.y).toBe(600)

  it "contains a certain point", ->
    expect(@hand.contains(new Point(400, 630))).toBe(true)
    expect(@hand.contains(new Point(100, 530))).toBe(false)

  describe "cards", ->
    it "contains card images", ->
      expect(@hand.cardImages.length).toBe(4)
