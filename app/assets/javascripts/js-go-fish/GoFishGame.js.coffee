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

  isEnded: ->
    for player in @players
      if player.hand().length == 0
        return true
    if @deck.numberOfCards() == 0
      return true
    false
  
  winner: ->
    if @isEnded()
      scoreOfAllPlayers = []
      for player in @players
        scoreOfAllPlayers.push(player.books.length)
      winner = @players[scoreOfAllPlayers.indexOf(scoreOfAllPlayers.maximumValue())]
      if scoreOfAllPlayers.count(scoreOfAllPlayers.maximumValue()) > 1
        winner = []
        for player in @players
          if player.books.length == scoreOfAllPlayers.maximumValue()
            winner.push(player)
      return winner
    else
      return false
