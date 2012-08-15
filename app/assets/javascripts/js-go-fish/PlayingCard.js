PlayingCard = function PlayingCard(rank, suit) {
	this._rank = rank;
	this._suit = suit;
}

PlayingCard.prototype.rank = function() {return this._rank; };
PlayingCard.prototype.suit = function() {return this._suit; };
