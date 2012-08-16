##= require ./Drawable

$ ->
  canvas = document.getElementById('drawing')
  if canvas
    drawing = new Drawing(canvas)
    drawing.paint()

window.Drawing = class Drawing extends Drawable
  constructor: (@canvas) ->
    @properties =
      lineWidth: 2
      strokeStyle: '#D4D4D4'
      fillStyle: 'green'
    circle1 = new Circle(100, 100, 50, {fillStyle: 'red'})
    circle2 = new Circle(500, 500, 50)
    @rect1 = new RoundedRectangle(300, 300, 140, 200, 10)
    # @figures = [circle1, circle2]
    @initializeMouseObservers() if @canvas

  paint: (context = @canvas.getContext('2d')) ->
    @draw(context)

  _draw: (context) ->
    # for figure in @figures
    #   figure.draw(context)
    # if !cardImage
    #   cardImage = new Image()
    #   cardImage.src = "./assets/c3.png"
    #   cardImage.onload = ->
    #     context.drawImage(cardImage, 100, 100, 64.8, 86.4)
    context.fillRect(600,100,200,100)
    context.fillStyle = 'black'
    context.font = "14pt Georgia"
    context.fillText("Drop here!", 650, 155)
    @rect1.draw(context)

  mouseMove: (point) ->
    if @selectedFigure and @canvas
      @selectedFigure.x = point.x() - @mouseOffsetX
      @selectedFigure.y = point.y() - @mouseOffsetY
      context = @canvas.getContext('2d')
      context.clearRect(0, 0, $(@canvas).width(), $(@canvas).height())
      @draw(context)
      if point.x() > 600 and point.x() < 800 and point.y() > 100 and point.y() < 200 and @selectedFigure
        console.log("it's at least valid")
        context.fillStyle = '#00DB00'
        context.fillRect(600,100,200,100)
        context.fillStyle = 'black'
        context.font = "14pt Georgia"
        context.fillText("Drop here!", 650, 155)
        @rect1.draw(context)

  mouseDown: (point) ->
    @selectedFigure = @rect1 if (@rect1.contains(point))
    @mouseOffsetX = point.x() - @selectedFigure.x
    @mouseOffsetY = point.y() - @selectedFigure.y

  mouseUp: (point) ->
    if point.x() > 600 and point.x() < 800 and point.y() > 100 and point.y() < 200 and @selectedFigure
      @selectedFigure = null
      context = @canvas.getContext('2d')
      console.log("Dropped!")
      context.clearRect(0, 0, $(@canvas).width(), $(@canvas).height())
      context.fillStyle = 'grey'
      context.fillRect(600,100,200,100)

      context.fillStyle = 'black'
      context.font = "bold 12px sans-serif"
      context.fillText("Dropped a #{@rect1.width} X #{@rect1.height} box!", 610, 120)
      @rect1.width = null
      @rect1.height = null
    @selectedFigure = null

  initializeMouseObservers: ->
    $(@canvas).on("mousedown", @mousedown_event.bind(this))
    $(@canvas).on("mousemove", @mousemove_event.bind(this))
    $(@canvas).on("mouseup", @mouseup_event.bind(this))

  mousedown_event: (event) ->
    @mouseDown(@mousePosition(event))

  mousemove_event: (event) ->
    @mouseMove(@mousePosition(event))

  mouseup_event: (event) ->
    @mouseUp(@mousePosition(event))

  mousePosition: (event) ->
    offset = $(@canvas).offset()
    new Point(event.clientX-offset.left, event.clientY-offset.top)

