$ ->
  window.Chainable = 
    set_next_prev: (@next, @prev) ->
    switch_next:    () -> @switch_to(@next) if @next
    switch_prev:    () -> @switch_to(@prev) if @prev
    switch_to: (other) -> 
      @hide() if @hide; 
      other.show() if other.show
