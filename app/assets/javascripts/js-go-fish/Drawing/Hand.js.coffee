##= require ./Drawable

window.Hand = class Hand extends Drawable
  constructor: (@cards, visible=no, backColor='blue') ->
    @cardImages = []
    for card in @cards
      cardImage = new Image()
      if visible
        cardImage.src = "./assets/#{card.suit().charAt(0).toLowerCase()}#{card.rank()}.png"
      else
        cardImage.src = "./assets/backs_#{backColor}.png"
      @cardImages.push(cardImage)
    console.log(@cards)
  
  drawAtPosition: (@x, @y, context) ->
    @draw(context)

  _draw: (context) ->
    [@x, @y] = [0, 0] if !@x and !@y
    width = @cards.length*64.8+40
    height = @cards.length*86.4+40
    gradient = context.createLinearGradient(@x, @y, width, height)
    gradient.addColorStop(0,"#D4D4D4")
    gradient.addColorStop(1,"#E3E3E3")
    background = new RoundedRectangle(@x, @y, width, height, {fillStyle: gradient})
