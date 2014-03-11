$ ->
  $('form.fileupload').each ->
    $(this).fileupload
      dataType: 'script'
      dropZone: $(this).find('.dropfile')
      add: (e, data) ->
        $(this).addClass('uploading');
        data.submit()