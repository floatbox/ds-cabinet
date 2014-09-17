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
    stop: () =>
      clearTimeout(@timeout)
    
    callback_1000: () =>
      if @counter > 0
        @counter -= 1
        $(@selector).html(@text(@counter))
      else
        @stop()
        $(@selector).html('')
        @callback() if @callback
      end
