window.Point = class Point
  constructor: (@_x, @_y) ->
  x: -> @_x
  y: -> @_y
  offsetBy: (point) ->
    new Point(@_x + point.x(), @_y + point.y())

  offsetByX: (xPoint) ->
    new Point(@_x + xPoint, @_y)

  offsetByY: (yPoint) ->
    new Point(@_x, @_y + yPoint)
