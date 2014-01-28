class Color
  constructor: (red, green, blue) ->
    @r = red
    @g = green
    @b = blue

  copy: ->
    return new Color(@r, @g, @b)

  merge: (color, alpha) ->
    @r = @r * (1-alpha) + color.r * alpha
    @g = @g * (1-alpha) + color.g * alpha
    @b = @b * (1-alpha) + color.b * alpha

  toRGB: ->
    return [Math.round(@r), Math.round(@g), Math.round(@b)].join()

