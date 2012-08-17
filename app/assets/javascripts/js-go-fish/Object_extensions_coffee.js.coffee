# Used by Player.js.coffee
Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

Array::count = (requestedElement) ->
  count = {}
  for element in this
    count[element] = (count[element] || 0) + 1
  if count[requestedElement]
    return count[requestedElement]
  else
    return 0

Array::select = (requestedElement) ->
  count = {}
  array = []
  for element in this
    count[element] = (count[element] || 0) + 1
  if count[requestedElement]
    for i in [1..count[requestedElement]]
      array.push(requestedElement)
    return array
  else
    return null

Array::maximumValue = ->
  Math.max.apply(0, this)

unless CanvasRenderingContext2D::extended
  CanvasRenderingContext2D::extended = true

  CanvasRenderingContext2D::drawImageAtPoint = (image, point, width, height) ->
    height = width if height == undefined
    @drawImage(image, point.x(), point.y(), width, height)
