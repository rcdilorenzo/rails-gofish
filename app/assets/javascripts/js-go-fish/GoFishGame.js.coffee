window.GoFishGame = class GoFishGame
  constructor: (playerNames...) ->
    @deck = new DeckOfCards
    playerNames = playerNames[0] if playerNames[0] instanceof Array
    @players = []
    for name in playerNames
      @players.push(new Player(name, this))
    @currentPlayer

  deal: ->
    player.addCard(@deck.draw()) for player in @players for count in [1..5]
