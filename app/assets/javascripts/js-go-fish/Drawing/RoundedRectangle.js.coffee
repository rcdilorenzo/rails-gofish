##= require ./Drawable

window.RoundedRectangle = class RoundedRectangle extends Drawable
  constructor: (@x, @y, @width, @height, @radius, @parameters={}) ->
  drawWithText: (context, @text, @textX, @textY) ->
    @draw(context)

  _draw: (context) ->
    # context.fillStyle = "#D4D4D4" if context.fillStyle == "#0000ff"
    context.beginPath()
    context.moveTo(@x + @radius, @y)
    context.arcTo(@x + @width, @y, @x + @width, @y + @height, @radius)
    context.arcTo(@x + @width, @y + @height, @x, @y + @height, @radius)
    context.arcTo(@x, @y + @height, @x, @y, @radius)
    context.arcTo(@x, @y, @x + @width, @y, @radius)
    context.closePath()
    context.fill()
    @drawText(context) if @text

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
