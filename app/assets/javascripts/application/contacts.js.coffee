$ -> 
  $('body').on 'click', '#contacts', (event) ->
    if $('.contacts').length == 0
      location.replace('/contacts')
      return false

    event.preventDefault()

    $('.registration_forms').fadeOut 400, ->
      $('.main-wrapper').removeClass('steps').addClass('wrap-content')
      $('.contacts').fadeIn(800)
      $('.promo').addClass('disabled').animate {height:'0px'}, 400, 'linear', ->
        $(this).hide()

    $('#pre_new_registration_form').fadeOut()

    false