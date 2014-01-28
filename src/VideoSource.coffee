class VideoSource
  constructor: ->
    @backgroundCanvas = $("#background-canvas")[0]
    @differenceCanvas = $("#difference-canvas")[0]
    @backgroundContext = @backgroundCanvas.getContext('2d')
    @differenceContext = @differenceCanvas.getContext('2d')

    @backgroundContext.translate(@backgroundCanvas.width, 0)
    @backgroundContext.scale(-1, 1)
    @isInitialized = false

  getVideoWidth: -> @backgroundCanvas.width

  getVideoHeight: -> @backgroundCanvas.height

  initialize: (callback) ->
    if Modernizr.getusermedia
      callback(false, "Sorry, you don't have webcam support.")

    gUM = Modernizr.prefixed('getUserMedia', navigator)
    gUM({video:true}, (localStream) =>
      @video = document.querySelector('video')
      @video.src = window.URL.createObjectURL(localStream)
      $(window).resize(=> @resize())
      @resize()
      @isInitialized = true
      callback(true)
    , (err) =>
      console.log(err)
      callback(false, "Could not open up webcam (" + err.name + ")")
    )
    @subscribers = []

  resize: ->
    $(@backgroundCanvas).width($(window).width())
    $(@backgroundCanvas).height($(window).height())
    $(@differenceCanvas).width($(window).width())
    $(@differenceCanvas).height($(window).height())

  update: ->
    return if not @isInitialized
    @backgroundContext.drawImage(@video, 0, 0, @video.width, @video.height)

    width = @backgroundCanvas.width
    height = @backgroundCanvas.height
    # compute difference
    sourceData = @backgroundContext.getImageData(0,0,width,height)
    if not @lastImageData
      @lastImageData = @backgroundContext.getImageData(0, 0, width, height)

    blendedData = @backgroundContext.createImageData(width, height)
    window.differenceAccuracy(blendedData.data, sourceData.data, @lastImageData.data)
    @differenceContext.putImageData(blendedData, 0, 0)
    @lastImageData = sourceData
    subscriber(sourceData, blendedData) for subscriber in @subscribers

  subscribeToUpdate: (subscriber) ->
    @subscribers.push(subscriber)

# Code from http://www.soundstep.com/blog/experiments/jsdetection/js/app.js
fastAbs = (value) ->
  
  # funky bitwise, equal Math.abs
  (value ^ (value >> 31)) - (value >> 31)

threshold = (value) ->
  (if (value > 0x15) then 0xFF else 0)

window.differenceAccuracy = (target, data1, data2) ->
  return null  unless data1.length is data2.length
  i = 0
  while i < (data1.length * 0.25)
    average1 = (data1[4 * i] + data1[4 * i + 1] + data1[4 * i + 2]) / 3
    average2 = (data2[4 * i] + data2[4 * i + 1] + data2[4 * i + 2]) / 3
    diff = threshold(fastAbs(average1 - average2))
    target[4 * i] = diff
    target[4 * i + 1] = diff
    target[4 * i + 2] = diff
    target[4 * i + 3] = 0xFF
    ++i
