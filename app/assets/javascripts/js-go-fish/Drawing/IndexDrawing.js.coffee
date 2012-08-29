##= require ./Drawable

$ ->
  canvas = document.getElementById('goFish')
  if canvas
    canvas.width = canvas.clientWidth
    canvas.height = canvas.clientHeight
    drawing = new FishDrawing(canvas)
    drawing.paint()

window.FishDrawing = class FishDrawing extends Drawable
  constructor: (@canvas) ->
    context = @canvas.getContext('2d') if @canvas
    @fish = []
    numberOfFish = window.innerWidth/8
    for count in [0..numberOfFish]
      newPoint = new Point(Math.floor(Math.random() * window.innerWidth-100), Math.floor(Math.random() * window.innerHeight-100))
      @fish.push(new Fish(context, newPoint))

  # generateXCoordinate: ->
  #   if Math.floor(Math.random()*2) == 0
  #     return Math.floor(Math.random() * window.innerWidth/2-194-100)
  #   else
  #     return Math.floor(Math.random() * window.innerWidth/2-194)+window.innerWidth+388


  paint: (context = @canvas.getContext('2d')) ->
    offset = 5
    totalOffset = 5
    goFishText = new Message("Go Fish")

    drawInterval = setInterval( =>
      @canvas.width = @canvas.clientWidth
      @canvas.height = @canvas.clientHeight
      context.clearRect(0, 0, $(@canvas).width(), $(@canvas).height()) if @canvas
      offset = Math.floor(Math.random() * 6)
      offset = offset*(-1) if totalOffset > 59 || totalOffset <= -15
      for fish in @fish
        fish.originalPoint.offsetByX(offset)
        fish.draw()

      textPoint = new Point(window.innerWidth/2-window.innerWidth/5, window.innerHeight/2.5)
      gradient = context.createLinearGradient(textPoint.x(), textPoint.y()-60, textPoint.x(), textPoint.y()+20)
      gradient.addColorStop(0, "#333333")
      gradient.addColorStop(1, "#1E1E1E")
      # context.lineWidth = 2
      # context.strokeStyle = "#1E1E1E"
      context.fillStyle = gradient
      context.font = "bold #{window.innerWidth/10}px Century Gothic"
      context.fillText("Go Fish", textPoint.x(), textPoint.y())
      # context.strokeText("Go Fish", textPoint.x(), textPoint.y())

      totalOffset = totalOffset + offset
    , 120)
