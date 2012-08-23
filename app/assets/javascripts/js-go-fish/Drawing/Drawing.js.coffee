##= require ./Drawable

$ ->
  canvas = document.getElementById('drawing')
  if canvas
    drawing = new Drawing(canvas)
    drawing.paint()
    $(".navbar").css("position", "absolute")

window.Drawing = class Drawing extends Drawable
  constructor: (@canvas) ->
    @game = new GoFishGame("Christian", "John", "Jay", "Ken")
    @hands = []
    @dropTargets = []
    @setupGame()
    context = @canvas.getContext('2d')
    @dealButton = new RoundedRectangle(430, 300, 100, 50, 10, {lineWidth: 0})
    
    @initializeMouseObservers() if @canvas
    @selectedCard = null


  # ------- Model ---------
  setupGame: ->
    @game.deal()
    player = @game.players[0]
    player.visualHand = new LivePlayerHand(player.name, player.hand(), 330, 600)

    player = @game.players[1]
    player.visualHand = new Hand(player.name, player.hand(), 50, 250, 'vertical')
    
    player = @game.players[2]
    player.visualHand = new Hand(player.name, player.hand(), 330, 50)
    
    player = @game.players[3]
    player.visualHand = new Hand(player.name, player.hand(), 779, 250, 'vertical')

    @hands.push(player.visualHand) for player in @game.players
    @dropTargets.push(player) for player in @game.players when player isnt @game.players[0]

  toJSON: ->
    {drawing: "Implement this feature..."}

  save: ->
    postURL = $(@canvas).data('save')
    $.post(postURL, @toJSON())


  # ------- Drawing ---------
  paint: (context = @canvas.getContext('2d')) ->
    myMessage = new Message(["Hello, this is awesome.", "This is another line."])
    myMessage.draw(@canvas, context, new Point(400, 400), {delay: 1.5, color: [0, 0, 0]})
    myMessage = new Message("3rd Line")
    myMessage.draw(@canvas, context, new Point(400, 440), {speed: 1, color: [255, 255, 255]})
    @draw(context)

  _draw: (context) ->
    hand.draw(context) for hand in @hands when hand isnt @hands[0]
    @hands[0].draw(context)
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
    for target in @dropTargets
      if target.visualHand.contains(point) and @selectedCard
        console.log("#{@selectedCard.getAttribute("data-rank")}\'s requested of #{target.name}")
    if @selectedCard
      @revertToOldPosition(@selectedCard)
      @selectedCard = null
  
  mouseOut: (point) ->
    context = @canvas.getContext('2d')
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
