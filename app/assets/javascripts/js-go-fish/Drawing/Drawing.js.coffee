##= require ./Drawable

$ ->
  canvas = document.getElementById('drawing')
  if canvas
    drawing = new Drawing(canvas)
    drawing.paint()
    $(".navbar").css("position", "absolute")

window.Drawing = class Drawing extends Drawable
  constructor: (@canvas) ->
    @game = new GoFishGame($(@canvas).attr('data-screenname'), "John", "Jay", "Ken")
    @hands = []
    @dropTargets = []
    context = @canvas.getContext('2d') if @canvas
    @dealButton = new RoundedRectangle(430, 300, 100, 50, 10, {lineWidth: 0})
    
    @initializeMouseObservers() if @canvas
    @selectedCard = null
    @setupGame()


  # ------- Model ---------
  setupGame: ->
    @game.deal()
    player = @game.players[0]
    player.visualHand = new LivePlayerHand(player, 330, 600)

    player = @game.players[1]
    player.visualHand = new Hand(player, 50, 240, 'vertical')
    
    player = @game.players[2]
    player.visualHand = new Hand(player, 205, 50)
    
    player = @game.players[3]
    player.visualHand = new Hand(player, 779, 240, 'vertical')

    @hands.push(player.visualHand) for player in @game.players
    @dropTargets.push(player) for player in @game.players when player isnt @game.players[0]
    @game.currentPlayer = @game.players[0]
    @paint()
    @takePlayerTurn()

  toYAML: ->
    if @game.isEnded()
      # Make Copy of Game
      currentGame = jQuery.extend(true, {}, @game)
      for player in currentGame.players
        delete player.game
        delete player.decision
        delete player.visualHand
      currentGame.winner = currentGame.winner()
      currentGame.currentPlayer = null
      console.log(YAML.stringify(currentGame))
      return YAML.stringify(currentGame)
    else
      return "The game hasn't ended"

  save: ->
    postURL = $(@canvas).data('save')
    $.post(postURL, {game: @toYAML(), authenticity_token: $(@canvas).data('token')})


  # ------- Game Events --------
  takePlayerTurn: ->
    if @game.isEnded()
      console.log("Game Ended")
      return @endGame()
    if @game.currentPlayer == @game.players[0]
      clearInterval(@gameLoopInterval)
    else
      clearInterval(@gameLoopInterval)
      @game.gameMessages = []
      decision = @createRobotDecision(@game.currentPlayer)
      @game.currentPlayer.decision.player = decision.player
      @game.currentPlayer.decision.rank = decision.rank
      @game.currentPlayer.takeTurn()
      @paint()

  livePlayerTurn: (context, point) ->
    for target in @dropTargets
      if target.visualHand.contains(point) and @selectedCard
        # LIVE PLAYER HAS TAKEN TURN
        @game.players[0].decision = {player: target, rank: @selectedCard.getAttribute("data-rank")}
        @game.currentPlayer.takeTurn()
        @clearCanvas(context)
        @game.players[0].visualHand.generateCreationPointsArray()
        @draw(context)
        @paint()

  createRobotDecision: (currentPlayer) ->
    opponents = []
    for player in @game.players
      if player isnt currentPlayer
        opponents.push player
    chosenPlayer = opponents[Math.floor(Math.random()*opponents.length)]
    chosenRank = currentPlayer.cards.arrayFromFunction("rank").maximumCardValue()
    return {player: chosenPlayer, rank: chosenRank}

  endGame: ->
    @clearCanvas()
    clearInterval(@gameLoopInterval)
    @gameLoopInterval = null
    if @game.winner() instanceof Array
      endMessages = ["Tie!"]
      for winner in @game.winner()
        endMessages.push("#{winner.name}: #{winner.score()} books!")
      @endMessage = new Message(endMessages)
    else
      @endMessage = new Message("#{@game.winner().name} wins with #{@game.winner().score()} books!")
    @endMessage.draw(@canvas.getContext('2d'), new Point(90, 350), {fontSize: "20pt", fontWeight: "bold", fade: false, maxWidth: 700}, @save()) if @canvas


  # ------- Drawing ---------
  paint: (context = @canvas.getContext('2d')) ->
    @clearCanvas(context)
    # Regenerate image locations for live player
    @game.players[0].visualHand.generateCreationPointsArray()

    @draw(context)

    @gameLoopInterval = setInterval( =>
      if @game.isEnded()
        console.log("Game Ended")
        return @endGame()

      @clearCanvas(context)
      for target in @dropTargets
        target.visualHand.isSelected = false
      @game.currentPlayer.visualHand.isSelected = true
      @game.currentPlayer.decision = {}

      @displayGameMessages(context, @takePlayerTurn())
      @dealButton = null if @dealButton
      @draw(context)
    , 100)

  displayGameMessages: (context, callback) ->
    if @game.gameMessages.length > 0
      gameMessage = new Message(@game.gameMessages)
      gameMessage.draw(context, new Point(310, 350), {delay:2}, callback) if context
      @game.gameMessages = [] if gameMessage.contains(@game.players[0].name) and gameMessage.contains("fish")
    return gameMessage


  _draw: (context) ->
    if @game.deck
      context.fillStyle = "#fff"
      deckMessageRect = new RoundedRectangle(390, 10, 135, 30, 5)
      deckMessageRect.drawWithMessage(context, new Point(10, 20), "Deck: #{@game.deck.numberOfCards()} cards", {maxWidth: 130, fade: off, fontSize:"12pt"})
    hand.draw(context) for hand in @hands when hand isnt @hands[0]
    @hands[0].draw(context)
    buttonGradient = context.createLinearGradient(430, 300, 430, 350)
    buttonGradient.addColorStop(0,"#79BBFF")
    buttonGradient.addColorStop(1,"#378DE5")
    context.fillStyle = buttonGradient
    @dealButton.drawWithText(context, "Deal!") if @dealButton

  revertToOldPosition: (card) ->
    context = @canvas.getContext('2d') if @canvas
    @clearCanvas(context)
    @game.players[0].visualHand.generateCreationPointsArray()
    @draw(context)

  clearCanvas: ->
    if @canvas
      context = @canvas.getContext('2d')
      context.clearRect(0, 0, $(@canvas).width(), $(@canvas).height()) if @canvas


  # ------- Mouse Events ---------
  mouseDown: (point) ->
    @dealButton = null if @dealButton
    if @game.players[0].visualHand.imageAtPoint(point) and @game.currentPlayer == @game.players[0]
      @selectedCard = @game.players[0].visualHand.imageAtPoint(point)
      @originalCardPosition = @game.players[0].visualHand.creationPoints[@selectedCard.src]
      @mouseOffsetX = point.x() - @game.players[0].visualHand.creationPoints[@selectedCard.src].x()
      @mouseOffsetY = point.y() - @game.players[0].visualHand.creationPoints[@selectedCard.src].y()

  mouseUp: (point) ->
    if @game.currentPlayer == @game.players[0]
      context = @canvas.getContext('2d') if @canvas
      @clearCanvas(context)
      @draw(context)
    @livePlayerTurn(context, point)
    if @selectedCard
      @revertToOldPosition(@selectedCard)
      @selectedCard = null
  
  mouseOut: (point) ->
    context = @canvas.getContext('2d')
    if @selectedCard
      @revertToOldPosition(@selectedCard)
      @selectedCard = null
  
  mouseMove: (point) ->
    if @selectedCard
      for target in @dropTargets
        if target.visualHand.contains(point) and @selectedCard
          target.visualHand.isSelected = true
        else
          target.visualHand.isSelected = false
        target.visualHand.draw(@canvas.getContext('2d')) if @canvas

      # @selectedCard.x = point.x() - @mouseOffsetX
      # @selectedCard.y = point.y() - @mouseOffsetY
      context = @canvas.getContext('2d') if @canvas
      @clearCanvas(context)
      @game.players[0].visualHand.creationPoints[@selectedCard.src] = new Point(point.x() - @mouseOffsetX, point.y() - @mouseOffsetY)
      @draw(context)


  # ------- Mouse Initializers ---------
  initializeMouseObservers: ->
    $(@canvas).on("mousedown", @mousedown_event.bind(this))
    $(@canvas).on("mouseup", @mouseup_event.bind(this))
    $(@canvas).on("mousemove", @mousemove_event.bind(this))
    $(@canvas).on("mouseout", @mouseout_event.bind(this))

  mousedown_event: (event) -> @mouseDown(@mousePosition(event))
  mousemove_event: (event) -> @mouseMove(@mousePosition(event))
  mouseup_event: (event) -> @mouseUp(@mousePosition(event))
  mouseout_event: (event) -> @mouseOut(@mousePosition(event))

  mousePosition: (event) ->
    offset = $(@canvas).offset()
    new Point(event.clientX-offset.left, event.clientY-offset.top)
