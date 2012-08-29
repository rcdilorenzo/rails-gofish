describe "Hand", ->
  beforeEach ->
    @myPlayer = new Player("John")
    @myPlayer.cards = [new PlayingCard(4, "Spades"), new PlayingCard(5, "Hearts"), new PlayingCard(4, "Diamonds"), new PlayingCard(4, "Clubs"), new PlayingCard("Jack", "Diamonds")]

    spyOn(Hand.prototype, 'getImage').andReturn('Test Card Object')
    @hand = new Hand(@myPlayer, 330, 600)

  it "inherits from Drawable", ->
    # check if a parent's method exists
    expect(@hand._saveAndSetProperties).not.toBe(null)

  describe "background", ->
    it "creates a rounded rectangle background", ->
      @hand.createBackground()
      expect(@hand.background instanceof RoundedRectangle).toBe(true)
    
    it "calculates correct width and height (horizontal orientation)", ->
      @hand.createBackground()
      expect(@hand.width).toBe(351)
      expect(@hand.height).toBe(166)

      @myPlayer.cards.push(new PlayingCard("Queen", "Spades"))
      @hand.createBackground()
      expect(@hand.width).toBe(371)
      expect(@hand.height).toBe(166)

    it "calculates correct width and height (vertical orientation)", ->
      @hand = new Hand(@myPlayer, 100, 100, 'vertical')
      @hand.createBackground()
      expect(@hand.width).toBe(111)
      expect(@hand.height).toBe(391)

      @myPlayer.cards.push(new PlayingCard("Queen", "Spades"))
      @hand.createBackground()
      expect(@hand.width).toBe(111)
      expect(@hand.height).toBe(411)

  describe "cards", ->
    it "contains card images", ->
      expect(@hand.cardImages.length).toBe(5)

    it "creates the correct offset for each card drawn", ->
      @hand.createBackground()
      expect(@hand.cardOffset).toBe(60)
