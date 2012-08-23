window.Player = class Player
  constructor: (@name, @game) ->
    @cards = []
    @books = []
    @decision = {}
  
  name: -> @name
  
  hand: -> @cards
  
  addCard: (card) -> @cards.push card

  giveCardsOfRank: (requestedRank) ->
    cardsOfRequestedRank = []
    for card in @cards
      if card.rank() == requestedRank
        cardsOfRequestedRank.push card
    for card in cardsOfRequestedRank
      @cards.splice(@cards.indexOf(card), 1)
    return cardsOfRequestedRank
  
  askPlayerForRank: (player, rank) ->
    cardsRequested = player.giveCardsOfRank(rank)
    if cardsRequested.length > 0
      for card in cardsRequested
        @cards.push(card)
      return cardsRequested
    else
      return this.goFish()
  
  goFish: ->
    @game.gameMessages.push("Go fish!")
    @cards.push(@game.deck.draw())
  
  countOfCardsWithRank: (rank) ->
    count = 0
    for card in @cards
      if card.rank() == rank
        count++
    return count

  checkForBooks: ->
    cardsForBook = []
    for card in @cards
      if this.countOfCardsWithRank(card.rank()) == 4
        cardsForBook.push card
    for card in cardsForBook
      @cards.remove(card)
    @books = @books.concat(cardsForBook)

  takeTurn: ->
    @game.gameMessages.push("#{@name} asks #{@decision.player} for any #{@decision.rank}\s!")
    returnedCards = this.askPlayerForRank(@decision.player, @decision.rank)
    for card in returnedCards
      @game.gameMessages.push("#{@decision.player.name} returns a #{card.rank()} of #{card.suit()}") unless card.rank() == 'Ace'
      @game.gameMessages.push("#{@decision.player.name} returns an #{card.rank()} of #{card.suit()}") if card.rank() == 'Ace'
    this.checkForBooks()
    @cards.sort = (a, b) ->
      a.rank - b.rank
    @game.currentPlayer = this if returnedCards.length != 0
    @game.currentPlayer = @decision.player if returnedCards.length == 0
