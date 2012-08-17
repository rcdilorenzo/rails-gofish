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
    dealButton = new RoundedRectangle(430, 300, 100, 50, 10, {lineWidth: 0})
    
    @drawElements = [dealButton]
    @initializeMouseObservers() if @canvas

  setupGame: ->
    @game.deal()
    player = @game.players[0]
    player.visualHand = new Hand(player.name, player.hand(), 330, 600, yes)

    player = @game.players[1]
    player.visualHand = new Hand(player.name, player.hand(), 50, 250, no, 'vertical')
    
    player = @game.players[2]
    player.visualHand = new Hand(player.name, player.hand(), 330, 50, no)
    
    player = @game.players[3]
    player.visualHand = new Hand(player.name, player.hand(), 779, 250, no, 'vertical')
    
    player = null
    @hands.push(player.visualHand) for player in @game.players


  paint: (context = @canvas.getContext('2d')) ->
    @draw(context)

  _draw: (context) ->
    for hand in @hands
      hand.draw(context)
    buttonGradient = context.createLinearGradient(430, 300, 430, 350)
    buttonGradient.addColorStop(0,"#79BBFF")
    buttonGradient.addColorStop(1,"#378DE5")
    context.fillStyle = buttonGradient
    @drawElements[0].drawWithText(context, "Deal!") if @drawElements[0]

  toJSON: ->
    {drawing: "Implement this feature..."}

  # mouseMove: (point)
  mouseDown: (point) ->
    # @drawElements[0].contains(point)

  mouseUp: (point) ->
    if @drawElements[0].contains(point)
      context = @canvas.getContext('2d')
      context.clearRect(0, 0, $(@canvas).width(), $(@canvas).height())
      @drawElements[0] = null
      @draw(context)

  save: ->
    postURL = $(@canvas).data('save')
    $.post(postURL, @toJSON())


  initializeMouseObservers: ->
    $(@canvas).on("mousedown", @mousedown_event.bind(this))
    $(@canvas).on("mouseup", @mouseup_event.bind(this))
    # $(@canvas).on("mousemove", @mousemove_event.bind(this))

  mousedown_event: (event) -> @mouseDown(@mousePosition(event))
  # mousemove_event: (event) -> @mouseMove(@mousePosition(event))
  mouseup_event: (event) -> @mouseUp(@mousePosition(event))

  mousePosition: (event) ->
    offset = $(@canvas).offset()
    new Point(event.clientX-offset.left, event.clientY-offset.top)




















