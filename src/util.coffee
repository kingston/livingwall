class Util
  @dist: (pt1, pt2) ->
    return Math.sqrt(Math.pow(pt1.x - pt2.x, 2) + Math.pow(pt1.y - pt2.y, 2))

  @gaussian: (x, breadth) ->
    return Math.exp(-Math.pow(x, 2) / 2 / breadth)

  @now: -> new Date().getTime()

  @randInt: (min, max) ->
    Math.floor((Math.random() * (max - min + 1)) + min)

  @rand: (min, max) ->
    (Math.random() * (max - min + 1)) + min

  @roundPt: (pt) ->
    return { x: Math.round(pt.x), y: Math.round(pt.y) }

  @movePt: (pt, delta, period) ->
    pt.x += delta.dx * period
    pt.y += delta.dy * period

class ImageUtil
  @averageBrightness: (data) ->
    average = 0
    average += data[i*4] + data[i*4+1] + data[i*4+2] for i in [0...data.length*0.25]
    return average / (data.length*0.25*3)

# taken from https://gist.github.com/gre/1650294
class Easing
  # no easing, no acceleration
  @linear: (t) ->
    t

  
  # accelerating from zero velocity
  @easeInQuad: (t) ->
    t * t

  
  # decelerating to zero velocity
  @easeOutQuad: (t) ->
    t * (2 - t)

  
  # acceleration until halfway, then deceleration
  @easeInOutQuad: (t) ->
    (if t < .5 then 2 * t * t else -1 + (4 - 2 * t) * t)

  
  # accelerating from zero velocity 
  @easeInCubic: (t) ->
    t * t * t

  
  # decelerating to zero velocity 
  @easeOutCubic: (t) ->
    (--t) * t * t + 1

  
  # acceleration until halfway, then deceleration 
  @easeInOutCubic: (t) ->
    (if t < .5 then 4 * t * t * t else (t - 1) * (2 * t - 2) * (2 * t - 2) + 1)

  
  # accelerating from zero velocity 
  @easeInQuart: (t) ->
    t * t * t * t

  
  # decelerating to zero velocity 
  @easeOutQuart: (t) ->
    1 - (--t) * t * t * t

  
  # acceleration until halfway, then deceleration
  @easeInOutQuart: (t) ->
    (if t < .5 then 8 * t * t * t * t else 1 - 8 * (--t) * t * t * t)

  
  # accelerating from zero velocity
  @easeInQuint: (t) ->
    t * t * t * t * t

  
  # decelerating to zero velocity
  @easeOutQuint: (t) ->
    1 + (--t) * t * t * t * t

  
  # acceleration until halfway, then deceleration 
  @easeInOutQuint: (t) ->
    (if t < .5 then 16 * t * t * t * t * t else 1 + 16 * (--t) * t * t * t * t)
