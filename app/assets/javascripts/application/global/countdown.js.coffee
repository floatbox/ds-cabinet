$ ->
  class window.Countdown
    constructor: (@selector, @from_value, @callback) ->
      @number = $(@selector)
      @reset()
    reset: () ->
      @number.html(@from_value)
    start: () ->
      setTimeout(@callback)
