window.Fish = class Fish
  constructor: (@fishContext, @originalPoint) ->
    @colorStops = @generateColorGradient()
    @size = Math.floor(Math.random()*100)/100 + 0.2
    @size = 0.8 if @size > 0.8
  hover: ->
    offset = 5
    totalOffset = 5
    drawInterval = setInterval( =>
      offset = Math.floor(Math.random() * 6)
      offset = offset*(-1) if totalOffset > 59 || totalOffset <= -15
      @originalPoint.offsetByX(offset)
      @draw()
      totalOffset = totalOffset + offset
    , 150)

  generateColorGradient: ->
    if Math.floor(Math.random()*2) == 0
      return ["#79BBFF", "#378DE5"]
    else
      return ["#F9BC28", "#FAA428"]
    
  draw: ->
    context = @fishContext
    context.save()
    x = @originalPoint.x() + Math.floor(Math.random() * 4) - 2
    y = @originalPoint.y() + Math.floor(Math.random() * 4) - 2
    # context.clearRect(x-(10*@size), y-(10*@size), (170*@size), (65*@size))

    context.beginPath()
    context.moveTo(x, y+(45*@size))
    context.bezierCurveTo(x+(47*@size), y-(18*@size), x+(125*@size), y-(5*@size), x+(130*@size), y+(23*@size))
    context.bezierCurveTo(x+(125*@size), y+(45*@size), x+(53*@size), y+(65*@size), x, y)
    context.closePath()
  
    gradient = context.createLinearGradient(x, y, x, y+65)
    gradient.addColorStop(0, @colorStops[0])
    gradient.addColorStop(1, @colorStops[1])
    
    context.fillStyle = gradient
    context.fill()
    context.lineWidth = @size*5
    context.strokeStyle = @colorStops[1]
    context.stroke()

    context.restore()
