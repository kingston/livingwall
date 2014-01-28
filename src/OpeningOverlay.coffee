class OpeningOverlayController
  constructor: (app) ->
    @overlay = $("#opening-overlay")

  run: ->
    @overlay.blurjs(
      source: 'body'
      radius: 5
    )
    # hide in 3 seconds
    setTimeout =>
      @overlay.fadeOut(1000)
    , 3000
