##= require ./Drawable

window.RoundedRectangle = class RoundedRectangle extends Drawable
  constructor: (@x, @y, @width, @height, @radius) ->
  drawWithText: (context, @text, @textX, @textY) ->
    @draw(context)
    @drawText(context)

  drawWithMessage: (context, offsetPoint, messageText, parameters={}) ->
    myMessage = new Message(messageText)
    @draw(context)
    myMessage.draw(context, new Point(@x + offsetPoint.x(), @y + offsetPoint.y()), parameters)

  _draw: (context) ->
    context.beginPath()
    context.moveTo(@x + @radius, @y)
    context.arcTo(@x + @width, @y, @x + @width, @y + @height, @radius)
    context.arcTo(@x + @width, @y + @height, @x, @y + @height, @radius)
    context.arcTo(@x, @y + @height, @x, @y, @radius)
    context.arcTo(@x, @y, @x + @width, @y, @radius)
    context.closePath()
    context.fill()

  drawText: (context) ->
    context.fillStyle = 'black'
    context.font = "14pt American Typewriter"
    if @textX and @textY
      context.fillText(@text, @x+@textX, @y+@textY)
    else
      context.fillText(@text, @x+25, @y+30)

  contains: (point) ->
    distanceX = point.x() - @x
    distanceY = point.y() - @y
    return distanceX <= @width and distanceX > -@radius and distanceY <= @height and distanceY > 0
