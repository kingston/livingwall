class OpeningOverlayController
  constructor: (app) ->
    @app = app
    @overlay = $("#opening-overlay")

  run: ->
    @overlay.blurjs(
      source: 'body'
      radius: 5
    )
    start = Util.now()
    @app.video.initialize((success, message)=>
      if not success
        $("#status").text(message)
        return

      # hide in 3 seconds
      diff = start + 3000 - Util.now()
      if diff < 0
        @overlay.fadeOut(1000)
      else
        setTimeout =>
          @overlay.fadeOut(1000)
        , diff
    )
