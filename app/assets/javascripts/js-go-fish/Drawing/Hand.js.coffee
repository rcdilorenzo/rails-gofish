##= require ./Drawable

window.Hand = class Hand extends Drawable
  constructor: (@name, @cards, @x, @y, @visible=no, @orientation='horizontal', @backColor='blue') ->
    @cardImages = []
    index = 0
    for card in @cards
      @cardImages.push(@createImage(card))
      index++

  _draw: (context) ->
    # [@x, @y] = [0, 0] if !@x and !@y
    @drawBackground(context)
    @drawName(context)
    @refreshImages(context)

  addCard: (card) ->
    @cards.push(@cards)
    @cardImages.push(@createImage(card))
    @draw(context)

  drawName: (context) ->
    context.fillStyle = 'black'
    context.font = "14pt American Typewriter"
    context.fillText(@name, @x+20, @y+30)

  drawBackground: (context) ->
    if @orientation == 'horizontal'
      @width = (@cards.length*40)+31+40
      @height = 166
    else
      @height = (@cards.length*40)+56+55
      @width = 111
    gradient = context.createLinearGradient(@x, @y, @width, @height)
    gradient.addColorStop(0,"#D4D4D4")
    gradient.addColorStop(1,"#E3E3E3")
    background = new RoundedRectangle(@x, @y, @width, @height, 10, {fillStyle: gradient})
    context.fillStyle = gradient
    background.draw(context)
    
  refreshImages: (context) ->
    creationPoint = new Point(@x+20, @y+50) if @orientation == 'horizontal'
    creationPoint = new Point(@x+20, @y+40) if @orientation == 'vertical'
    for cardImage in @cardImages
      @displayImage(context, cardImage, creationPoint)
      creationPoint = creationPoint.offsetByX(40) if @orientation == 'horizontal'
      creationPoint = creationPoint.offsetByY(40) if @orientation == 'vertical'
      # context.drawImage(cardImage, creationPoint.x(), creationPoint.y(), 71, 96)

  createImage: (card) ->
    cardImage = new Image()
    if @visible
      if typeof card.rank() == "number"
        cardImage.src = "./assets/#{card.suit().charAt(0).toLowerCase()}#{card.rank()}.png"
      else
        cardImage.src = "./assets/#{card.suit().charAt(0).toLowerCase()}#{card.rank().charAt(0).toLowerCase()}.png"
    else
      cardImage.src = "./assets/backs_#{@backColor}.png"
    return cardImage

  displayImage: (context, cardImage, point) ->
    context.drawImage(cardImage, point.x(), point.y(), 71, 96)
