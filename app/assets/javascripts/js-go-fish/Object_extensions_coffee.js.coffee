# Used by Player.js.coffee
Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1
