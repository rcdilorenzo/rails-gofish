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
      fillStyle: 'blue'
    circle1 = new Circle(100, 100, 50, {fillStyle: 'red'})
    circle2 = new Circle(500, 500, 50)
    @figures = [circle1, circle2]

  paint: (context = @canvas.getContext('2d')) ->
    @draw(context)

  _draw: (context) ->
    context.fillRect(0,0,100,100)
    for figure in @figures
      figure.draw(context)
