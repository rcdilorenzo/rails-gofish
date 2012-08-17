# Used by Player.js.coffee
Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

unless CanvasRenderingContext2D::extended
  CanvasRenderingContext2D::extended = true

  CanvasRenderingContext2D::drawImageAtPoint = (image, point, width, height) ->
    height = width if height == undefined
    @drawImage(image, point.x(), point.y(), width, height)
