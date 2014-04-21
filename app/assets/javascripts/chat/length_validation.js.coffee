$ ->
  $('body').on 'keyup', '#topic_text, #message_text', ->
    length = $(this).val().replace("\r\n", "\n").length
    if length > 1200
      $('.text_error span').text(length)
      $('.text_error').show()
    else
      $('.text_error').hide()