describe "GoFishGame", ->
  beforeEach -> @game = new GoFishGame("Rack", "Shack", "Benny")

  it "should have players with names", ->
    expect(@game.players[0].name).toBe("Rack")
    expect(@game.players[1].name).toBe("Shack")
    expect(@game.players[2].name).toBe("Benny")
  
  it "can tell players to take turns", ->
    firstPlayer = @game.players[0]
    @game.deal()
    firstPlayer.decision = {
      player: @game.players[1],
      rank: firstPlayer.cards[0].rank()
    }
    console.log(firstPlayer.decision)
    firstPlayer.takeTurn()
    expect(firstPlayer.hand().length).toBe(6)

  describe "deal", ->
    it "deals each player 5 cards", ->
      @game.deal()
      expect(@game.players[0].hand().length).toBe(5)
      expect(@game.players[1].hand().length).toBe(5)
      expect(@game.players[2].hand().length).toBe(5)

  describe "isEnded", ->
    it "should be ended if the deck is empty", ->
      @game.deal()
      expect(@game.isEnded()).toBe(false)
      @game.deck.cards = []
      expect(@game.isEnded()).toBe(true)

    it "should be ended if a player's hand is empty", ->
      @game.deal()
      expect(@game.isEnded()).toBe(false)
      @game.players[2].cards = []
      expect(@game.isEnded()).toBe(true)

  describe "winner", ->
    it "should determine the winner if the game has ended", ->
      @game.deal()
      expect(@game.winner()).toBe(false)
      @game.players[0].books = [[null, null, null, null]]
      @game.players[1].books = [[null, null, null, null], [null, null, null, null]]
      @game.players[2].books = []
      @game.deck.cards = [] # Ends the game
      expect(@game.winner()).toBe(@game.players[1])

    it "should determine the winners if the game has ended and is a tie", ->
      @game.deal()
      expect(@game.winner()).toBe(false)
      @game.players[0].books = [[null, null, null, null], [null, null, null, null]]
      @game.players[1].books = [[null, null, null, null], [null, null, null, null]]
      @game.players[2].books = []
      @game.deck.cards = [] # Ends the game
      console.log(@game.winner().length)
      expect(@game.winner()).toEqual([@game.players[0], @game.players[1]])
