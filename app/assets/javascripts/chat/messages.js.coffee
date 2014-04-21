$ ->
  $('form.fileupload').each ->
    $(this).fileupload
      dataType: 'script'
      dropZone: $(this).find('.dropfile')
      add: (e, data) ->
        $(this).addClass('uploading')
        $(this).fadeTo('fast', 0.5)
        data.submit()
      done: (e, data) ->
        $(this).fadeTo('fast', 1.0)