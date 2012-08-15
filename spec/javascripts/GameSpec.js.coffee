describe "GoFishGame", ->
  beforeEach -> @game = new GoFishGame("Rack", "Shack", "Benny")

  it "should have players with names", ->
    expect(@game.players[0].name).toBe("Rack")
    expect(@game.players[1].name).toBe("Shack")
    expect(@game.players[2].name).toBe("Benny")

  it "deals each player 5 cards", ->
    @game.deal()
    expect(@game.players[0].hand().length).toBe(5)
    expect(@game.players[1].hand().length).toBe(5)
    expect(@game.players[2].hand().length).toBe(5)

  it "tells players to take turns", ->
    firstPlayer = @game.players[0]
    @game.deal()
    firstPlayer.decision = {
      player: @game.players[1],
      rank: firstPlayer.cards[0].rank()
    }
    console.log(firstPlayer.decision)
    firstPlayer.takeTurn()
    expect(firstPlayer.hand().length).toBe(6)
