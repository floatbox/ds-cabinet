$ ->
  $('body').on 'ajax:success', '.js-new_session form', (event, data) ->
    location.replace('/')

  $('body').on 'ajax:error', '.js-new_session form', (event, data) ->
    $('.js-forms_container').effect('shake')
