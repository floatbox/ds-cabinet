$ ->
  class window.Preloader
    @show: (e) ->
      e = $(e)
      if e.length
        eLeft = e.offset().left + parseInt(e.css('margin-left')) + parseInt(e.css('border-left-width'))
        eTop = e.offset().top
        eWidth = e.outerWidth(true)
        eHeight = e.outerHeight(true)
        preloader = $('img#preloader')
        width = preloader.width()
        height = preloader.height()
        eLeft += (parseInt(e.css('padding-left')) - width)/2
        preloader.css('left', "#{eLeft}px")
        preloader.css('left', "#{eLeft}px")
        preloader.css('top',  "#{eTop  + (eHeight - height)/2 }px")
        e.fadeTo('fast', 0.5)
        preloader.show()

    @hide: (form) ->
      form = $(form)
      form.stop(true).fadeTo('fast', 1.0)
      $('img#preloader').hide()
