##= require ./Drawable

$ ->
  canvas = document.getElementById('goFish')
  if canvas
    $('body').css('background', "url(../img/water-texture-#{Math.floor(Math.random() * 2)+1}.jpg) repeat")
    canvas.width = canvas.clientWidth
    canvas.height = canvas.clientHeight
    drawing = new FishDrawing(canvas)
    drawing.paint()
    $(window).resize( =>
      clearInterval(drawing.drawInterval)
      drawing = null
      context.clearRect(0, 0, $(@canvas).width(), $(@canvas).height()) if @canvas
      drawing = new FishDrawing(canvas)
      drawing.paint()
     )

  backgroundPosition = 0
  movingBackground = setInterval( =>
    $('body').animate({
      'background-position': "#{backgroundPosition}px 0"
    }, 9)
    backgroundPosition -= 1
  , 50)


window.FishDrawing = class FishDrawing extends Drawable
  constructor: (@canvas) ->
    context = @canvas.getContext('2d') if @canvas
    @fish = []
    numberOfFish = window.innerWidth/8
    numberOfFish = window.innerWidth/4 if window.innerWidth < 800
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

    @drawInterval = setInterval( =>
      @canvas.width = @canvas.clientWidth
      @canvas.height = @canvas.clientHeight
      context.clearRect(0, 0, $(@canvas).width(), $(@canvas).height()) if @canvas
      offset = Math.floor(Math.random() * 6)
      offset = offset*(-1) if totalOffset > 59 || totalOffset <= -15
      for fish in @fish
        fish.originalPoint.offsetByX(offset)
        fish.draw()

      textPoint = new Point(window.innerWidth/2-window.innerWidth/5.8, window.innerHeight/2.5)
      gradient = context.createLinearGradient(textPoint.x(), textPoint.y()-80, textPoint.x(), textPoint.y()+10)
      gradient.addColorStop(0, "#3962A6")
      gradient.addColorStop(1, "#30538C")
      context.lineWidth = window.innerWidth/900
      context.strokeStyle = "#213961"
      context.fillStyle = gradient
      context.font = "bold #{window.innerWidth/10}px Century Gothic"
      context.fillText("Go Fish", textPoint.x(), textPoint.y())
      context.strokeText("Go Fish", textPoint.x(), textPoint.y())

      totalOffset = totalOffset + offset
    , 200)
