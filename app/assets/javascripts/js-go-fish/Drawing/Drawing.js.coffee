##= require ./Drawable

$ ->
  canvas = document.getElementById('drawing')
  if canvas
    drawing = new Drawing(canvas)
    drawing.paint()

window.Drawing = class Drawing extends Drawable
  constructor: (@canvas) ->
    @game = new GoFishGame("Christian", "John", "Jay", "Ken")
    @hands = []
    @setupGame()
    context = @canvas.getContext('2d')
    @dealButton = new RoundedRectangle(430, 300, 100, 50, 10, {lineWidth: 0})
    
    @initializeMouseObservers() if @canvas
    @selectedCard = null
    @dropTargets = []


  # ------- Model ---------
  setupGame: ->
    @game.deal()
    player = @game.players[1]
    player.visualHand = new Hand(player.name, player.hand(), 50, 250, 'vertical')
    @hands.push(player.visualHand)
    
    player = @game.players[2]
    player.visualHand = new Hand(player.name, player.hand(), 330, 50)
    @hands.push(player.visualHand)
    
    player = @game.players[3]
    player.visualHand = new Hand(player.name, player.hand(), 779, 250, 'vertical')
    @hands.push(player.visualHand)
    
    player = @game.players[0]
    player.visualHand = new LivePlayerHand(player.name, player.hand(), 330, 600)
    @hands.push(player.visualHand)

  toJSON: ->
    {drawing: "Implement this feature..."}


  # ------- Drawing ---------
  paint: (context = @canvas.getContext('2d')) ->
    @draw(context)

  _draw: (context) ->
    for hand in @hands
      hand.draw(context)
    buttonGradient = context.createLinearGradient(430, 300, 430, 350)
    buttonGradient.addColorStop(0,"#79BBFF")
    buttonGradient.addColorStop(1,"#378DE5")
    context.fillStyle = buttonGradient
    @dealButton.drawWithText(context, "Deal!") if @dealButton

  revertToOldPosition: (card) ->
    context = @canvas.getContext('2d')
    context.clearRect(0, 0, $(@canvas).width(), $(@canvas).height())
    @game.players[0].visualHand.creationPoints[@selectedCard.src] = @originalCardPosition
    @draw(context)


  # ------- Mouse Events ---------
  mouseDown: (point) ->
    @dealButton = null if @dealButton
    if @game.players[0].visualHand.imageAtPoint(point)
      @selectedCard = @game.players[0].visualHand.imageAtPoint(point)
      @originalCardPosition = @game.players[0].visualHand.creationPoints[@selectedCard.src]
      @mouseOffsetX = point.x() - @game.players[0].visualHand.creationPoints[@selectedCard.src].x()
      @mouseOffsetY = point.y() - @game.players[0].visualHand.creationPoints[@selectedCard.src].y()

  mouseUp: (point) ->
    context = @canvas.getContext('2d')
    context.clearRect(0, 0, $(@canvas).width(), $(@canvas).height())
    @draw(context)
    if @selectedCard
      @revertToOldPosition(@selectedCard)
      @selectedCard = null
  
  mouseOut: (point) ->
    context = @canvas.getContext('2d')
    context.clearRect(0, 0, $(@canvas).width(), $(@canvas).height())
    @draw(context)
    if @selectedCard
      @revertToOldPosition(@selectedCard)
      @selectedCard = null
  
  mouseMove: (point) ->
    if @selectedCard and @canvas
      # @selectedCard.x = point.x() - @mouseOffsetX
      # @selectedCard.y = point.y() - @mouseOffsetY
      context = @canvas.getContext('2d')
      context.clearRect(0, 0, $(@canvas).width(), $(@canvas).height())
      @game.players[0].visualHand.creationPoints[@selectedCard.src] = new Point(point.x() - @mouseOffsetX, point.y() - @mouseOffsetY)
      @draw(context)

  save: ->
    postURL = $(@canvas).data('save')
    $.post(postURL, @toJSON())

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
