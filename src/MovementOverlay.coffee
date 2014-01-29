class MovementOverlay extends ColorSource
  constructor: (app, controller, w, h) ->
    @video = app.video
    @controller = controller
    app.video.subscribeToUpdate((source, blended)=> @updateColors(source,blended))
    @w = w
    @h = h
    @colors = new ColorMatrix(w, h, new Color(0,0,0))
    @colors2 = new ColorMatrix(w, h, new Color(0,0,0))
    @brightnessHistory = []
    for i in [0...w*h]
      @brightnessHistory.push(0)

  updateColors: (source, blended) ->
    black = new Color(0,0,0)
    if @firstUpdate
      return if Util.now() - @firstUpdate < 500
    else
      @firstUpdate = Util.now()
    dampingRatio = 0.1
    # update brightnesses from movement
    hueFactor = Easing.easeInQuint(1-@controller.lastBrightness)
    console.log(hueFactor)
    for x in [0...@w]
      for y in [0...@h]
        # get appropriate brightness from canvas
        vw = @video.getVideoWidth()
        vh = @video.getVideoHeight()
        dotw = Math.floor(vw / @w)
        doth = Math.floor(vh / @h)

        average = 0
        data = blended.data

        for vx in [x*dotw...(x+1)*dotw]
          for vy in [y*doth...(y+1)*doth]
            i = vy * vw + vx
            average += data[i*4]

        brightness = average / (dotw * doth)

        bh = @brightnessHistory[y*@w+x]
        bh = bh * 0.7 + (brightness * 1.5 / 256.0) * 0.3
        @brightnessHistory[y*@w+x] = bh
        hue = Easing.easeInQuad(0 + (1-bh) * 1 * hueFactor)

        # add random factor
        hue += Math.random() / 10 - 0.05
        hue = Math.max(0, Math.min(1, hue))

        if brightness > 10
          newColor = Color.fromHSV(hue, brightness / 256, brightness / 256)
          # screen with theme color
          @colors.screen(x, y, newColor)

    # disperse colors
    for x in [0...@w]
      for y in [0...@h]
        # get average color
        rsum = 0.0
        gsum = 0.0
        bsum = 0.0
        for dx in [-1..1]
          for dy in [-1..1]
            continue if x + dx < 0 or x + dx >= @w
            continue if y + dy < 0 or y + dy >= @h
            continue if Math.abs(dx) == Math.abs(dy)
            color = @colors.getAt(x + dx, y + dy)
            rsum += color.r
            gsum += color.g
            bsum += color.b

        color = @colors2.getAt(x,y)
        r = color.r
        g = color.g
        b = color.b
        mergedColor = new Color(rsum / 2 - r, gsum / 2 - g, bsum / 2 - b)
        @colors2.set(x, y, mergedColor)
        @colors2.getAt(x,y).darken(dampingRatio)

    # swap buffers
    colorsBak = @colors2
    @colors2 = @colors
    @colors = colorsBak

  addColor: (matrix, time) ->
    for x in [0...@w]
      for y in [0...@h]
        matrix.screen(x, y, @colors.getAt(x, y))
        matrix.add(x, y, @colors.getAt(x, y), 0.2)
    return true
