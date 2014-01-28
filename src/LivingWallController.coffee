class LivingWallController
  constructor: (app) ->
    @settings = app.settings

    @dotsw = Math.floor($(window).width() / @settings.dotWidth)
    @dotsh = Math.floor($(window).height() / @settings.dotWidth)

    @display = new app.settings.displayClass(@dotsw, @dotsh)
    @diffuseSources = []

    @lightness = 0 # out of 1

  initialize: ->
    @diffuseSources.push(new DiffuseLightSource(new Color(20, 0, 0)))

  run: ->
    @initialize()
    @display.initialize((time) => @getColors(time))
 
  getColors: (time) ->
    start = @lightness * 256
    baseColor = new Color(start, start, start)
    colors = new ColorMatrix(@dotsw, @dotsh, baseColor)

    for source in @diffuseSources
      source.addColor(colors, time)

    return colors
