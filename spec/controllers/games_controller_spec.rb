require 'spec_helper'

describe GamesController do
  it "should parse a YAML javascript game to ruby" do
    controller = GamesController.new
    game_YAML = File.open("./spec/controllers/example_javascript_game.yaml").read
    parsedGame = controller.parse_YAML_JS_game(game_YAML)
    parsedGame.should be_kind_of GoFishGame
    parsedGame.deck_of_cards.cards.should eq([])
    # Check Cards
    parsedGame.players[0].cards.should eq([Card.new(10, "Diamonds"),
                                          Card.new("Jack", "Hearts"),
                                          Card.new(4, "Diamonds"),
                                          Card.new("Jack", "Clubs"),
                                          Card.new(10, "Clubs"),
                                          Card.new(6, "Clubs"),
                                          Card.new("Jack", "Spades"),
                                          Card.new(6, "Spades"),
                                          Card.new(10, "Spades")])
    parsedGame.players[1].cards.should eq([Card.new(5, "Diamonds"),
                                          Card.new(3, "Clubs"),
                                          Card.new(4, "Spades"),
                                          Card.new(5, "Spades"),
                                          Card.new(5, "Clubs"),
                                          Card.new(4, "Hearts"),
                                          Card.new(3, "Spades")])
    parsedGame.players[2].cards.should eq([Card.new(4, "Clubs"),
                                          Card.new(9, "Hearts"),
                                          Card.new(3, "Hearts"),
                                          Card.new(2, "Diamonds"),
                                          Card.new(8, "Spades"),
                                          Card.new(3, "Diamonds"),
                                          Card.new(8, "Hearts"),
                                          Card.new(9, "Spades"),
                                          Card.new(9, "Clubs"),
                                          Card.new(6, "Hearts"),
                                          Card.new("Jack", "Diamonds"),
                                          Card.new(8, "Clubs")])
    parsedGame.players[3].cards.should eq([Card.new(6, "Diamonds"),
                                          Card.new(5, "Hearts"),
                                          Card.new(2, "Spades"),
                                          Card.new(2, "Clubs"),
                                          Card.new(2, "Hearts"),
                                          Card.new(10, "Hearts"),
                                          Card.new(8, "Diamonds"),
                                          Card.new(9, "Diamonds")])
    # Check Books
    parsedGame.players[0].books.should eq([])
    parsedGame.players[1].books.should eq([[Card.new("King", "Diamonds"),
                                          Card.new("King", "Clubs"),
                                          Card.new("King", "Spades"),
                                          Card.new("King", "Hearts")],
                                          [Card.new("Queen", "Diamonds"),
                                          Card.new("Queen", "Spades"),
                                          Card.new("Queen", "Clubs"),
                                          Card.new("Queen", "Hearts")],
                                          [Card.new(7, "Spades"),
                                          Card.new(7, "Clubs"),
                                          Card.new(7, "Hearts"),
                                          Card.new(7, "Diamonds")]])
    parsedGame.players[2].books.should eq([])
    parsedGame.players[3].books.should eq([[Card.new("Ace", "Diamonds"),
                                          Card.new("Ace", "Hearts"),
                                          Card.new("Ace", "Clubs"),
                                          Card.new("Ace", "Spades")]])
    parsedGame.winner.name.should eq("John")
  end
end
