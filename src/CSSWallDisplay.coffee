class CSSWallDisplay extends WallDisplay
  initialize: (screenCallback) ->
    super screenCallback

    @wallDiv = $("<div id='circle-container'>")
    # create dots
    @dotDivs = []
    for i in [0...@dotsw*@dotsh]
      left = #

      dot = $("<div>").addClass('dot')
      @dotDivs.push(dot)
      @wallDiv.append(dot)

    @layoutDots()
    @updateScreen()

    $("body").append(@wallDiv)

    # start updates
    @interval = setInterval(=>
      @updateScreen()
    , 300)

    $(window).resize(=>
      @layoutDots()
    )

  layoutDots: ->
    screenWidth = $(window).width()
    screenHeight = $(window).height()

    dotWidth = Math.floor(Math.min(screenWidth / @dotsw, screenHeight / @dotsh))
    contentWidth = dotWidth * @dotsw
    contentHeight = dotWidth * @dotsh

    leftOffset = Math.round((screenWidth - contentWidth) / 2.0)
    topOffset = Math.round((screenHeight - contentHeight) / 2.0)
    for i in [0...@dotDivs.length]
      row = Math.floor(i / @dotsw)
      col = i % @dotsw

      left = dotWidth * col + leftOffset
      top = dotWidth * row + topOffset

      @dotDivs[i].css("left", left)
        .css("top", top)
        .css("width", dotWidth)
        .css("height", dotWidth)

    return null

  updateScreen: ->
    time = new Date().getTime()
    data = @callback(time)
    # color dots
    for i in [0...@dotDivs.length]
      color = data.get(i)
      @dotDivs[i].css("background-color", "rgb(" + color.toRGB() + ")")

