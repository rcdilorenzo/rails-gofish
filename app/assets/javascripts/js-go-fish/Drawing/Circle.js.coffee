##= require ./Drawable

window.Circle = class Circle extends Drawable
  constructor: (@x, @y, @radius, @properties={}) ->
  _draw: (context) ->
    context.beginPath()
    context.arc(@x,@y,@radius,0,Math.PI*2,true)
    context.closePath()
    context.fill()
    context.stroke()
