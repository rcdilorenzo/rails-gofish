##= require ./Hand

window.LivePlayerHand = class LivePlayerHand extends Hand
  generateCreationPointsArray: ->
    @creationPoints = {}
    creationPoint = new Point(@x+20, @y+50)
    for cardImage in @cardImages
      @creationPoints[cardImage.src] = creationPoint
      creationPoint = creationPoint.offsetByX(40)

  _draw: (context) ->
    @x = @originalX + (5-@cardImages.length)*20
    @drawBackground(context)
    @drawName(context)
    @refreshImages(context)

  drawBackground: (context) ->
    @width = (@player.cards.length*40)+31+40
    @height = 166

    if @isSelected
      gradient = context.createLinearGradient(@x, @y, @x+@width, @y+@height)
      gradient.addColorStop(0,"#F8FFC8")
      gradient.addColorStop(1,"#D4DAAB")
      @isSelected = false
    else
      gradient = context.createLinearGradient(@x, @y, @width, @height)
      gradient.addColorStop(0,"#D4D4D4")
      gradient.addColorStop(1,"#E3E3E3")
    
    background = new RoundedRectangle(@x, @y, @width, @height, 10, {fillStyle: gradient})
    context.fillStyle = gradient
    background.draw(context)

  refreshImages: (context) ->
    if @player.cards.length != @cardImages.length
      @generateCardImagesArray()
      @generateCreationPointsArray()
    else
      @generateCardImagesArray()
    for cardImage in @cardImages
      @displayImage(context, cardImage, @creationPoints[cardImage.src])

  getImage: (card) ->
    if typeof card.rank() == "number"
      cardImage = $("##{card.suit().charAt(0).toLowerCase()}#{card.rank()}")[0]
    else
      cardImage = $("##{card.suit().charAt(0).toLowerCase()}#{card.rank().charAt(0).toLowerCase()}")[0]
    return cardImage

  imageAtPoint: (point) ->
    for image in @cardImages
      cardX = image.getAttribute("data-x")
      cardY = image.getAttribute("data-y")
      cardWidth = image.getAttribute("width")[0..-3] - 30
      if _i == @cardImages.length-1
        cardWidth = cardWidth + 30
      else if cardY == @x+40
        cardWidth = cardWidth + 30
      cardHeight = image.getAttribute("height")[0..-3]

      distanceX = point.x() - cardX
      distanceY = point.y() - cardY

      if distanceX <= cardWidth and distanceX > 0 and distanceY <= cardHeight and distanceY > 0
        return image
    return null
