window.Player = class Player
  constructor: (name, game) ->
    @name = name
    @game = game
    @cards = []
    @books = []
  
  name: -> @name
  
  hand: -> @cards
  
  addCard: (card) -> @cards.push card

  askPlayerForRank: (player, rank) ->
    cardsRequested = player.giveCardsOfRank(rank)
    if cardsRequested.length > 0
      for card in cardsRequested
        @cards.push(card)
      return cardsRequested
    else
      return this.goFish()
  
  giveCardsOfRank: (requestedRank) ->
    cardsOfRequestedRank = []
    for card in @cards
      if card.rank() == requestedRank
        cardsOfRequestedRank.push card
    for card in cardsOfRequestedRank
      @cards.splice(@cards.indexOf(card), 1)
    return cardsOfRequestedRank
  
  goFish: ->
    @cards.push(@game.deck().draw())
  
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
