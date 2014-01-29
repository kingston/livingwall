class LivingWallController
  constructor: (app) ->
    @app = app
    @settings = app.settings

    @dotsw = Math.floor($(window).width() / @settings.dotWidth)
    @dotsh = Math.floor($(window).height() / @settings.dotWidth)

    @display = new app.settings.displayClass(@dotsw, @dotsh)
    @diffuseSources = []

    @lightness = 0 # out of 1
    @themeColor = new Color(0, 0, 30)
    @panicColor = new Color(255, 0, 0)

  addRandomDiffuseSource: ->
    color = @themeColor.copy().merge(Color.getRandom(), 0.15)
    location = { x: Util.randInt(0, @dotsw), y: Util.randInt(0, @dotsh)}
    duration = Util.randInt(4000, 20000)
    @diffuseSources.push(new DiffuseLightSource(color, duration, location))

  initialize: ->
    @addRandomDiffuseSource()
    @addRandomDiffuseSource()
    @addRandomDiffuseSource()

    @overlay = new MovementOverlay(@app, @, @dotsw, @dotsh)

    @app.video.subscribeToUpdate((source, blended)=>
      @updateEmotions(source, blended)
    )

  run: ->
    @initialize()
    @display.initialize((time) => @getColors(time))
 
  getColors: (time) ->
    # update video source
    @app.video.update()

    baseColor = new Color(255, 255, 255)
    baseColor.merge(@themeColor, 1 - @lightness)
    colors = new ColorMatrix(@dotsw, @dotsh, baseColor)

    # add diffuse
    sourcesToRemove = []
    for source in @diffuseSources
      if not source.addColor(colors, time)
        sourcesToRemove.push(source)
    for source in sourcesToRemove
      @diffuseSources.splice(@diffuseSources.indexOf(source), 1)
      @addRandomDiffuseSource()

    # add overlay
    @overlay.addColor(colors, time)

    if @panic > 0.1
      colors.forEach((i, color) =>
        color.merge(@panicColor, @panic)
      )
      @panic = @panic * 0.95

    return colors

  updateEmotions: (source, blended) ->
    @firstEmotionUpdate = Util.now() unless @firstEmotionUpdate
    diff = Util.now() - @lastEmotionUpdate
    brightness = (ImageUtil.averageBrightness(blended.data)) / 256
    if (brightness - @lastBrightness) / (diff / 1000) > 1.2
      if Util.now() - @firstEmotionUpdate > 1000
        @panic = 1
        @themeColor = new Color(200,0,0)
    #@lightness = @lightness * 0.8 + brightness * 0.2
    red = Math.min(256, brightness * 256 * 2.5)
    green = Math.min(256, brightness * 128 * 2.5)
    blue = 30
    newColor = new Color(red, green, blue)
    if Util.now() - @firstEmotionUpdate > 1000
      @themeColor.screen(newColor)
      @themeColor.merge(newColor, 0.01)

    @lastBrightness = brightness
    @lastEmotionUpdate = Util.now()
