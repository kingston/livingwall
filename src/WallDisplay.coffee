class WallDisplay
  constructor: (dotsw, dotsh) ->
    @dotsw = dotsw
    @dotsh = dotsh

  initialize: (screenCallback) ->
    @callback = screenCallback
