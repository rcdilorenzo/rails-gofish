describe "Drawing", ->
  beforeEach ->
    spyOn($.fn, "attr").andReturn('winnerjohn65')
    spyOn(Drawing.prototype, 'paint').andReturn(null)
    spyOn(Drawing.prototype, 'draw').andReturn(null)
    @drawing = new Drawing(null)
    @game = @drawing.game
    jasmine.Clock.useMock()

  it "inherits from Drawable", ->
    # check if a parent's method exists
    expect(@drawing.draw).not.toBe(undefined)

  describe "setup", ->
    it "creates a deal button", ->
      expect(@drawing.dealButton instanceof RoundedRectangle).toBeTruthy()

    it "creates a game from the canvas's data-screenname", ->
      expect(@game.players[0].name).toEqual('winnerjohn65')

    it "assigns each player a visual hand", ->
      for player in @game.players when player isnt @drawing.game.players[0]
        expect(player.visualHand instanceof Hand).toBeTruthy()
      expect(@game.players[0].visualHand instanceof LivePlayerHand).toBeTruthy()

      for hand in @drawing.hands
        expect(@game.players.arrayFromProperty('visualHand').contains(hand)).toBeTruthy()

    it "creates drop targets for the non-live players", ->
      expect(@drawing.dropTargets).not.toBe(null)
      opponents = []
      opponents.push(player) for player in @game.players when player isnt @game.players[0]
      for target in @drawing.dropTargets
        expect(opponents.contains(target)).toBeTruthy()

  describe "player turns", ->
    it "creates a valid robot decision from the highest ranking card", ->
      @game.currentPlayer = @drawing.game.players[1]
      @game.currentPlayer.cards = [new PlayingCard(5, "Hearts"),
                                    new PlayingCard(4, "Spades"),
                                    new PlayingCard("Jack", "Diamonds"),
                                    new PlayingCard(3, "Clubs")]
      decision = @drawing.createRobotDecision(@game.currentPlayer)
      expect(decision.rank).toBe('Jack')
      expect(@game.players.contains(decision.player)).toBeTruthy()

    it "creates a decision for the live player only when a card is dragged to another player", ->
      @game.currentPlayer = @game.players[0]
      @drawing.selectedCard = new MockSelectedCardWithRank(3)

      # Test Invalid Drag
      @drawing.livePlayerTurn(null, new Point(206, 49))
      expect(@game.players[0].decision).toEqual({})

      # Test Valid Drag
      @drawing.livePlayerTurn(null, new Point(206, 51))
      expect(@game.players[0].decision.player).toBe(@game.players[2])
      expect(@game.players[0].decision.rank).toBe(3)

    it "displays messages between turns", ->
      @game.currentPlayer = @game.players[1]
      @drawing.takePlayerTurn()
      expect(@drawing.displayGameMessages().text.length > 1).toBeTruthy()

  describe "dragging", ->
    it "moves live player's card when clicked and dragged", ->
      # Create a fake selected card to be mocked
      cardImageToBeSelected = new MockSelectedCardWithRank(4)
      @game.players[0].visualHand.creationPoints[cardImageToBeSelected.src] = new Point(350, 650)

      # Return the mocked card when selected card is checked
      spyOn(@game.players[0].visualHand, 'imageAtPoint').andReturn(cardImageToBeSelected)
      mousePosition = new Point(372, 686)

      expect(@drawing.selectedCard).toBe(null)
      @drawing.mouseDown(mousePosition)
      expect(@drawing.selectedCard).toBe(cardImageToBeSelected)

      mousePosition = new Point(382, 696)
      @drawing.mouseMove(mousePosition)
      expect(@game.players[0].visualHand.creationPoints[cardImageToBeSelected.src]).toEqual(new Point(360, 660))

    it "pops the live player's card back to hand if dropped", ->
      # Create a fake selected card to be mocked
      cardImageToBeSelected = new MockSelectedCardWithRank(4)
      @game.players[0].visualHand.creationPoints[cardImageToBeSelected.src] = new Point(350, 650)

      # Return the mocked card when selected card is checked
      spyOn(@game.players[0].visualHand, 'imageAtPoint').andReturn(cardImageToBeSelected)
      mousePosition = new Point(372, 686)

      expect(@drawing.selectedCard).toBe(null)
      @drawing.mouseDown(mousePosition)
      expect(@drawing.selectedCard).toBe(cardImageToBeSelected)

      mousePosition = new Point(392, 706)
      @drawing.mouseMove(mousePosition)
      expect(@game.players[0].visualHand.creationPoints[cardImageToBeSelected.src]).toEqual(new Point(370, 670))

      mousePosition = new Point(350, 350)
      @game.players[0].visualHand.cardImages = [cardImageToBeSelected]
      @drawing.mouseUp(mousePosition)
      expect(@game.players[0].visualHand.creationPoints[cardImageToBeSelected.src]).toEqual(new Point(350, 650))

  describe "end of game", ->
    it "displays a tie message when the game is over if players are tied", ->
      spyOn(@game, 'isEnded').andReturn(true)
      @drawing.takePlayerTurn()
      expect(@drawing.endMessage).not.toBe(null)
      expect(@drawing.endMessage.text.contains("Tie!")).toBeTruthy()

    it "displays a winner message when the game is over if a specific player wins", ->
      @game.players[0].books = [null, null, null, null]
      spyOn(@game, 'isEnded').andReturn(true)
      @drawing.takePlayerTurn()
      expect(@drawing.endMessage).not.toBe(null)
      expect(@drawing.endMessage.text.contains("winnerjohn65 wins with 1 books!")).toBeTruthy()

  describe "data save", ->
    it "removes recursion before the game's YAML conversion", ->
      spyOn(@game, 'winner').andReturn(@game.players[1])
      spyOn(@game, 'isEnded').andReturn(true)
      gameInYAML = @drawing.toYAML()
      parsedYAMLGame = YAML.parse(gameInYAML)
      for count in [0..3]
        # Jasmine didn't like a "for" loop for the parsedYAMLGame's players
        expect(parsedYAMLGame.players[count].visualHand).not.toBeDefined()
        expect(parsedYAMLGame.players[count].decision).not.toBeDefined()
        expect(parsedYAMLGame.players[count].game).not.toBeDefined()
        expect(parsedYAMLGame.players[count].cards).toBeDefined()
      expect(parsedYAMLGame.winner.name).toBe(@game.players[1].name)

    it "converts game to YAML at the end of the game", ->
      expect(@drawing.toYAML()).toMatch(/game.*n.t.*end/)
      spyOn(@game, 'isEnded').andReturn(true)
      gameInYAML = @drawing.toYAML()
      expect(typeof gameInYAML == 'string').toBeTruthy()
      expect(YAML.parse(gameInYAML) instanceof Object).toBeTruthy()

# This class mimics the HTML Image Element so that a test
# can be made for retriving a card's data-rank attribute

window.MockSelectedCardWithRank = class MockSelectedCardWithRank
  constructor: (@returnRank) ->
    @src = "c2.png"
  getAttribute: ->
    if @returnRank
      return @returnRank
    else
      return "Jack"
