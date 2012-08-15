GoFishGame = function GoFishGame() {
  self.deck = new DeckOfCards
}

GoFishGame.prototype = {
  deck: function() {
    return self.deck;
  }
}
