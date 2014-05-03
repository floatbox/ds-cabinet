$ ->
  $('a#sign_in').on 'click', ->
    $('#new_session').toggle('fold')

  $('body').on 'ajax:success', '#new_session form', (event, data) ->
    location.reload()

  $('body').on 'ajax:error', '#new_session form', (event, data) ->
    $(this).closest('.subscribe-form').effect('shake')

  $('.subscribe-form #phone').mask('+7 (999) 999-99-99')