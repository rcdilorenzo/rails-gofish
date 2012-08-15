window.DeckOfCards = class DeckOfCards
  constructor: ->
    @cards = []
    ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']
    suits = ['Clubs', 'Diamonds', 'Hearts', 'Spades']
    for rank in ranks
      for suit in suits
        @cards.push(new PlayingCard(rank, suit))
  numberOfCards: -> @cards.length
  draw: ->
    randomIndex = Math.floor(Math.random()*this.cards.length)
    return @cards.splice(randomIndex, 1)[0]
  hasCards: -> @cards.length > 0
