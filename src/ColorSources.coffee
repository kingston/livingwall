class ColorMatrix
  constructor: (w, h, baseColor) ->
    @colors = []
    @w = w
    @h = h
    for i in [0...@w*@h]
      @colors.push(baseColor.copy())

  screen: (x, y, color) ->
    @colors[y * @w + x].screen(color)

  set: (x, y, color) ->
    @colors[y * @w + x] = color

  add: (x, y, color, alpha) ->
    @colors[y * @w + x].merge(color, alpha)

  get: (i) -> @colors[i]

  getAt: (x, y) -> @colors[y * @w + x]

  forEach: (callback) ->
    $.each(@colors, callback)

class ColorSource
  addColor: (matrix, time) ->
    return false

class WaveLightSource extends ColorSource
  constructor: (color) ->
    @center = {x: 0, y: 0}
    @breadth = 50
    @displacement = 0
    @color = color
    @amplitude = 1

  updateWaveCharacteristics: (time) ->

  addColor: (colors, time) ->
    result = @updateWaveCharacteristics(time)
    for x in [0...colors.w]
      for y in [0...colors.h]
        dist = Util.dist(@center, {x: x, y: y}) - @displacement
        color = @color

        # compute Gaussian
        factor = Util.gaussian(dist, @breadth)

        alpha = @amplitude * factor
        colors.add(x, y, color, alpha)
    return result

class DiffuseLightSource extends WaveLightSource
  constructor: (color, duration, startLoc) ->
    super color
    @startTime = Util.now()
    @duration = duration
    @setInEase = duration * 0.2
    @easingFunc = Easing.easeInCubic
    @location = startLoc
    @vel = { dx: Util.rand(-0.1, 0.1), dy: Util.rand(-0.1, 0.1) }
    @intervalPeriod = 0.2

    @interval = setInterval(=>
      @updateLocation()
    , @intervalPeriod * 1000)

  updateWaveCharacteristics: (time) ->
    @updateLocation(time)
    diff = time - @startTime
    if diff < @setInEase
      @amplitude = @easingFunc(diff / @setInEase)
    else if diff > @duration - @setInEase
      @amplitude = @easingFunc((@duration - diff) / @setInEase)
    else
      @amplitude = 1
    # move center around
    @center = @location
    isGood = diff < @duration
    if not isGood
      clearInterval @interval
    return isGood

  updateLocation: () ->
    accel = 0.05
    @vel.dx += accel * (Math.random() - 0.5)
    @vel.dy += accel * (Math.random() - 0.5)
    Util.movePt(@location, @vel, @intervalPeriod)
