$ ->
  class window.Countdown
    constructor: (@selector, @from_value, @callback) ->
    text: (val) =>
      " через #{val} сек."
    reset: () =>
      @counter = @from_value
      $(@selector).html('')
    
    start: () =>
      @reset()
      @timeout = setTimeout(@callback_1000, 1000)
      $(@selector).html(@text(@counter))
    stop: () =>
      clearTimeout(@timeout)
    
    callback_1000: () =>
      clearTimeout(@timeout)
      @counter -= 1
      if @counter > 0
        $(@selector).html(@text(@counter))
        @timeout = setTimeout(@callback_1000, 1000)
      else
        @stop()
        $(@selector).html('')
        @callback() if @callback
