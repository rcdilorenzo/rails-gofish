window.Drawable = class Drawable
  constructor: ->
  draw: (context) ->
    @_saveAndSetProperties(context)
    @_draw(context)
    @_restoreProperties(context)

  _saveAndSetProperties: (context) ->
    context.save()
    for name, value of @properties
      context[name] = value

  _draw: (context) ->
    context.fill()

  _restoreProperties: (context) ->
    context.restore()
