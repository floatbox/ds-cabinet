$ ->
  class window.Dialog 
    @put_text: (text_arr, is_error) ->
      content_div_html = text_arr.map (e) -> "<p>#{e}</p>"
      @put_html(content_div_html, is_error)
    @put_html: (content_div_html, is_error) ->
      dialog_div  = $('.js-Dialog')
      content_div = dialog_div.find('.js-modal-content')
      content_div.html(content_div_html)
      dialog_div.modal("show")
    @info_text: (text_arr) -> @put_text(text_arr, false)
    @error_text: (text_arr) -> @put_text(text_arr, true)
    @info_html: (html) -> @put_html(html, false)
    @error_html: (html) -> @put_html(html, true)
    @show_errors_json: (errors)->
      err_arr = []
      for attribute, messages of errors
        err_arr.push "#{LOCALE[attribute]}: #{messages.join(', ')}"
      @error_text(err_arr)
