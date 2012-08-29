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

  differenceTo: (point) ->
    new Point(point.x() - @_x, point.y() - @_y)

  isEqualTo: (point) ->
    @_x == point.x() and @_y == point.y()

  isGreaterThanOrEqualTo: (point) ->
    @_x >= point.x() and @_y >= point.y()
