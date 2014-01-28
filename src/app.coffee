$(->
  settings =
    displayClass: CSSWallDisplay
    dotWidth: 40
  app = new LivingWallApp(settings)
  app.run()
)

class LivingWallApp
  constructor: (settings) ->
    @startingControllers = [OpeningOverlayController, LivingWallController]
    @settings = settings

  run: ->
    for controller in @startingControllers
      c = new controller(this)
      c.run()
