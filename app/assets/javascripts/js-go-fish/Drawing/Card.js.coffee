##= require ./Drawable

window.RoundedRectangle = class RoundedRectangle extends Drawable
  constructor: (@x, @y, @width, @height, @radius, @parameters={}) ->
  _draw: (context) ->
    # context.fillStyle = "#D4D4D4" if context.fillStyle == "#0000ff"
    context.lineWidth = 5
    context.beginPath()
    context.moveTo(@x + @radius, @y)
    context.arcTo(@x + @width, @y, @x + @width, @y + @height, @radius)
    context.arcTo(@x + @width, @y + @height, @x, @y + @height, @radius)
    context.arcTo(@x, @y + @height, @x, @y, @radius)
    context.arcTo(@x, @y, @x + @width, @y, @radius)
    context.closePath()
    context.fill()
    context.stroke()

  contains: (point) ->
    distanceX = point.x() - @x
    distanceY = point.y() - @y
    return distanceX <= @width and distanceX > -@radius and distanceY <= @height and distanceY > 0

