$ ->
  window.Delegator =
    delegates: (methods, to) ->
      methods.forEach (method) =>
        @[method] = (args...) ->
          @[to][method].apply(@[to], args)

