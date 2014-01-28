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
    return @

  toRGB: ->
    return [Math.round(@r), Math.round(@g), Math.round(@b)].join()

  screen: (color) ->
    @r = Math.max(@r, color.r)
    @g = Math.max(@g, color.g)
    @b = Math.max(@b, color.b)

  darken: (percentage) ->
    @r = @r * (1-percentage)
    @g = @g * (1-percentage)
    @b = @b * (1-percentage)

  @getRandom: () ->
    new Color(Util.randInt(0, 256), Util.randInt(0, 256), Util.randInt(0, 256))

  @fromHSV: (h, s, v) ->
    if (h && s == undefined && v == undefined)
        s = h.s
        v = h.v
        h = h.h

    i = Math.floor(h * 6)
    f = h * 6 - i
    p = v * (1 - s)
    q = v * (1 - f * s)
    t = v * (1 - (1 - f) * s)
    switch i % 6
      when 0
        r = v
        g = t
        b = p
      when 1
        r = q
        g = v
        b = p
      when 2
        r = p
        g = v
        b = t
      when 3
        r = p
        g = q
        b = v
      when 4
        r = t
        g = p
        b = v
      when 5
        r = v
        g = p
        b = q
    return new Color(Math.floor(r * 255), Math.floor(g * 255), Math.floor(b * 255))
