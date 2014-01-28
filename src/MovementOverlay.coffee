class MovementOverlay extends ColorSource
  constructor: (app, w, h) ->
    @video = app.video
    app.video.subscribeToUpdate((source, blended)=> @updateColors(source,blended))
    @w = w
    @h = h
    @colors = new ColorMatrix(w, h, new Color(0,0,0))
    @brightnessHistory = []
    for i in [0...w*h]
      @brightnessHistory.push(0)

  updateColors: (source, blended) ->
    black = new Color(0,0,0)
    if @firstUpdate
      return if Util.now() - @firstUpdate < 500
    else
      @firstUpdate = Util.now()
    propagationRate = 0.3
    dampingRatio = 0.1
    # update brightnesses from movement
    for x in [0...@w]
      for y in [0...@h]
        # get appropriate brightness from canvas
        vw = @video.getVideoWidth()
        vh = @video.getVideoHeight()
        dotw = vw / @w
        doth = vh / @h
        blendedData = @video.differenceContext.getImageData(x * dotw, y * doth, dotw, doth)
        brightness = ImageUtil.averageBrightness(blendedData.data)

        bh = @brightnessHistory[y*@w+x]
        bh = bh * 0.7 + (brightness / 256.0) * 0.3
        @brightnessHistory[y*@w+x] = bh
        hue = 0.7 - bh * 0.6

        if brightness > 10
          newColor = Color.fromHSV(hue, brightness / 256, brightness / 256)
          @colors.screen(x, y, newColor)

    # disperse colors
    for x in [0...@w]
      for y in [0...@h]
        # get average color
        rsum = 0.0
        gsum = 0.0
        bsum = 0.0
        count = 0.0
        for dx in [-1..1]
          for dy in [-1..1]
            continue if x + dx < 0 or x + dx >= @w
            continue if y + dy < 0 or y + dy >= @h
            color = @colors.getAt(x + dx, y + dy)
            rsum += color.r
            gsum += color.g
            bsum += color.b
            count++
        mergedColor = new Color(rsum / count, gsum / count, bsum / count)
        @colors.add(x, y, mergedColor, propagationRate)
        @colors.getAt(x,y).darken(0.1)

  addColor: (matrix, time) ->
    for x in [0...@w]
      for y in [0...@h]
        matrix.screen(x, y, @colors.getAt(x, y))
        matrix.add(x, y, @colors.getAt(x, y), 0.2)
    return true
