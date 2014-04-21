$ ->
  $('body').on 'click', '.expand_messages', (event) ->
    event.preventDefault()
    $(this).hide()
    $(this).closest('.row').find('.messages').fadeIn()
    false