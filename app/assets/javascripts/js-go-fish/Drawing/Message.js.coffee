window.Message = class Message
  constructor: (@text) ->

  createDefaultParameters: ->
    # Creates values if only some parameters are passed
    @parameters.color = [0, 0, 0] unless @parameters.color
    @parameters.delay = 1 unless @parameters.delay
    @parameters.speed = 5 unless @parameters.speed
    @parameters.font = "American Typewriter" unless @parameters.font
    @parameters.fontWeight = "" unless @parameters.fontWeight

  draw: (canvas, context, point, @parameters={}) ->
    @createDefaultParameters()
    if canvas
      # Draw Inital Text and Wait for 100-(delay*1000) millseconds before fading
      context.clearRect(point.x(), point.y()-16, 300, 20)
      context.font = "#{@parameters.fontWeight} 16pt #{@parameters.font}"
      console.log(@parameters)
      context.fillStyle = "rgba(#{@parameters.color[0]}, #{@parameters.color[1]}, #{@parameters.color[2]}, 1.0)"
      if typeof @text == "string"
        context.fillText(@text, point.x(), point.y(), 300)
      else
        yOffset = 0
        for line in @text
          context.fillText(line, point.x(), point.y()+yOffset, 300)
          yOffset += 18

      unless @parameters.speed == null
        @waitInterval = setInterval(=>
          @fadeOut(canvas, context, point, @parameters.speed)
        , @parameters.delay*1000)

  fadeOut: (canvas, context, point) ->
    context.save()
    alpha = 1.0

    fadeInterval = setInterval( =>
      context.font = "#{@parameters.fontWeight} 16pt #{@parameters.font}"
      if typeof @text == "string"
        context.clearRect(point.x(), point.y()-16, 300, 20)
        context.fillStyle = "rgba(#{@parameters.color[0]}, #{@parameters.color[1]}, #{@parameters.color[2]}, #{alpha})"
        context.fillText(@text, point.x(), point.y(), 300)
      else
        yOffset = 0
        context.clearRect(point.x(), point.y()-16, 300, 20*@text.length)
        for line in @text
          context.fillStyle = "rgba(#{@parameters.color[0]}, #{@parameters.color[1]}, #{@parameters.color[2]}, #{alpha})"
          context.fillText(line, point.x(), point.y()+yOffset, 300)
          yOffset += 18
      alpha = alpha - 0.05
      clearInterval(@waitInterval) if @waitInterval

      if alpha < 0
        if typeof @text == "string"
          context.clearRect(point.x(), point.y()-16, 300, 20)
        else
          context.clearRect(point.x(), point.y()-16, 300, 20*@text.length)
        clearInterval(fadeInterval)
    , 100-(@parameters.speed*10))
    context.restore()
