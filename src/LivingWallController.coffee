class LivingWallController
  constructor: (app) ->
    @settings = app.settings

    @dotsw = Math.floor($(window).width() / @settings.dotWidth)
    @dotsh = Math.floor($(window).height() / @settings.dotWidth)

    @display = new app.settings.displayClass(@dotsw, @dotsh)

  run: ->
    @display.initialize((time) => @getColors(time))
 
  getColors: (time) ->
    colors = []
    for y in [1..@dotsh]
      for x in [1..@dotsw]
        colors.push(new Color(200, 100, 100))
    return colors
