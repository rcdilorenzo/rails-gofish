DeckOfCards = function DeckOfCards() {
  var ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"];
  var suits = ["Clubs", "Spades", "Diamonds", "Hearts"];
  this.cards = [];

  for (suitIndex in suits) {
    for (rankIndex in ranks) {
      this.cards.push(new PlayingCard(ranks[rankIndex], suits[suitIndex]));
    }
  }
}

DeckOfCards.prototype = {
  numberOfCards: function() {
    return this.cards.length;
  },
  draw: function() {
    var randomIndex = Math.floor(Math.random()*this.cards.length);
    return this.cards.splice(randomIndex, 1)[0];
  },
  hasCards: function() {
    return this.cards.length != 0;
  }
}
