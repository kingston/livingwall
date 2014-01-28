class ColorMatrix
  constructor: (w, h, baseColor) ->
    @colors = []
    @w = w
    @h = h
    for i in [0...@w*@h]
      @colors.push(baseColor.copy())

  set: (x, y, color) ->
    @colors[y * @w + x] = color

  add: (x, y, color, alpha) ->
    @colors[y * @w + x].merge(color, alpha)

  get: (i) -> @colors[i]

class ColorSource
  addColor: (matrix, time) ->
    return false

class WaveLightSource extends ColorSource
  constructor: (color) ->
    @center = {x: 0, y: 0}
    @breadth = 100
    @displacement = 0
    @color = color
    @amplitude = 1

  updateWaveCharacteristics: (time) ->

  addColor: (colors, time) ->
    @updateWaveCharacteristics(time)
    for x in [0...colors.w]
      for y in [0...colors.h]
        dist = Util.dist(@center, {x: x, y: y}) - @displacement
        color = @color

        # compute Gaussian
        factor = Math.exp(-Math.pow(dist, 2) / 2 / @breadth)

        alpha = @amplitude * factor
        colors.add(x, y, color, alpha)
    return true

class DiffuseLightSource extends WaveLightSource
  updateWaveCharacteristics: (time) ->
    # move center around
    @center = { x: 10, y: 10 }
