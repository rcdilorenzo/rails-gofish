describe "Player", ->
  beforeEach ->
    @game = new GoFishGame
    @player = new Player("Christian", @game)
    @otherPlayer = new Player("John", @game)
    @player.cards = []
    @otherPlayer.cards = []

  it "should have a name", ->
    expect(@player.name).toBe("Christian")

  describe "hand", ->
    it "should be able to add a card to its hand", ->
      @player.addCard(new PlayingCard(3, "Spades"))
      expect(@player.hand().length).toBe(1)
      expect(@player.hand()[0].rank()).toBe(3)
      expect(@player.hand()[0].suit()).toBe("Spades")

  describe "askPlayerForRank", ->
    it "should be able to ask another player for a card", ->
      # @player.addCard(new PlayingCard(3, "Spades"))
      console.log(@player.askPlayerForRank(@otherPlayer, 3));
      # expect(@player.askPlayerForRank(@otherPlayer, 3).not.toBe(null))

    it "should give the requested cards", ->
      @player.cards = [new PlayingCard(3, "Spades"),
                        new PlayingCard(5, "Diamonds"),
                        new PlayingCard(8, "Clubs")]
      @otherPlayer.addCard(new PlayingCard(3, "Hearts"))
      @player.askPlayerForRank(@otherPlayer, 3)
      expect(@otherPlayer.hand().length).toBe(0)

  describe "goFish", ->
    it "should go fish if other player doesn't have requested card", ->
      @player.cards = [new PlayingCard(3, "Spades"),
                        new PlayingCard(5, "Diamonds"),
                        new PlayingCard(8, "Clubs")]
      @otherPlayer.addCard(new PlayingCard(4, "Hearts"))
      @player.askPlayerForRank(@otherPlayer, 3)
      @expect(@player.hand().length).toBe(4)

  describe "checkForBooks", ->
    it "should create a book and remove those cards from hand if four of rank are in hand", ->
      @player.cards = [new PlayingCard(4, "Spades"),
                        new PlayingCard(5, "Hearts"),
                        new PlayingCard(4, "Diamonds"),
                        new PlayingCard(4, "Clubs")]
      @otherPlayer.addCard(new PlayingCard(4, "Hearts"))
      @player.askPlayerForRank(@otherPlayer, 4)
      @player.checkForBooks()
      expect(@otherPlayer.hand().length).toBe(0)
      expect(@player.books.length).toBe(4)
      expect(@player.hand().length).toBe(1)
