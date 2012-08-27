window.Message = class Message
  constructor: (@text) ->

  createDefaultParameters: ->
    # Creates values if only some parameters are passed
    @parameters.color = [0, 0, 0] unless @parameters.color
    @parameters.delay = 1 unless @parameters.delay
    @parameters.speed = 5 unless @parameters.speed
    @parameters.font = "American Typewriter" unless @parameters.font
    @parameters.fontWeight = "" unless @parameters.fontWeight
    @parameters.fontSize = "16pt" unless @parameters.fontSize
    @parameters.fade = true unless @parameters.fade == false
    @parameters.maxWidth = 450 unless @parameters.maxWidth
    @parameters.fontSizeNumber = parseInt(@parameters.fontSize[0..-3])

  draw: (context, point, @parameters={}, @callback=null) ->
    @createDefaultParameters()
    if context
      # Draw Inital Text and Wait for 100-(delay*1000) millseconds before fading
      # context.clearRect(point.x(), point.y()-@parameters.fontSizeNumber, @parameters.maxWidth, 25)
      context.font = "#{@parameters.fontWeight} #{@parameters.fontSize} #{@parameters.font}"
      context.fillStyle = "rgba(#{@parameters.color[0]}, #{@parameters.color[1]}, #{@parameters.color[2]}, 1.0)"
      if typeof @text == "string"
        context.fillText(@text, point.x(), point.y(), @parameters.maxWidth)
      else
        yOffset = 0
        for line in @text
          context.fillText(line, point.x(), point.y()+yOffset, @parameters.maxWidth)
          yOffset += parseInt(@parameters.fontSize[0..-3])+4

      unless @parameters.speed == null
        @waitInterval = setInterval(=>
          if @parameters.fade
            @fadeOut(context, point, @parameters.speed)
          else
            callback(@callbackFunction) if @callbackFunction
          clearInterval(@waitInterval) if @waitInterval
        , @parameters.delay*1000)

  fadeOut: (context, point) ->
    context.save()
    alpha = 1.0

    fadeInterval = setInterval( =>
      context.font = "#{@parameters.fontWeight} #{@parameters.fontSize} #{@parameters.font}"
      if typeof @text == "string"
        context.clearRect(point.x(), point.y()-@parameters.fontSizeNumber, @parameters.maxWidth, 25)
        context.fillStyle = "rgba(#{@parameters.color[0]}, #{@parameters.color[1]}, #{@parameters.color[2]}, #{alpha})"
        context.fillText(@text, point.x(), point.y(), @parameters.maxWidth)
      else
        yOffset = 0
        context.clearRect(point.x(), point.y()-@parameters.fontSizeNumber, @parameters.maxWidth, 25*@text.length)
        for line in @text
          context.fillStyle = "rgba(#{@parameters.color[0]}, #{@parameters.color[1]}, #{@parameters.color[2]}, #{alpha})"
          context.fillText(line, point.x(), point.y()+yOffset, @parameters.maxWidth)
          yOffset += 20
      alpha = alpha - 0.05
      clearInterval(@waitInterval) if @waitInterval

      if alpha < 0
        if typeof @text == "string"
          context.clearRect(point.x(), point.y()-@parameters.fontSizeNumber, @parameters.maxWidth, 25)
        else
          context.clearRect(point.x(), point.y()-@parameters.fontSizeNumber, @parameters.maxWidth, 25*@text.length)
        clearInterval(fadeInterval)
        callback(@callbackFunction) if @callbackFunction
    , 100-(@parameters.speed*10))
    context.restore()

  contains: (string) ->
    if typeof @text == "string"
      return @text.contains(string)
    else
      for line in @text
        return true if line.contains(string)
      return false
