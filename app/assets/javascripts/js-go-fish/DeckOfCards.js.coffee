window.DeckOfCards = class DeckOfCards
  constructor: ->
    @cards = []
    ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']
    suits = ['Clubs', 'Diamonds', 'Hearts', 'Spades']
    for rank in ranks
      for suit in suits
        @cards.push(new PlayingCard(rank, suit))
  numberOfCards: -> @cards.length if @cards
  draw: ->
    if @cards
      randomIndex = Math.floor(Math.random()*this.cards.length)
      return @cards.splice(randomIndex, 1)[0]
    else
      return null
  hasCards: ->
    return @cards.length > 0 if @cards
    false
