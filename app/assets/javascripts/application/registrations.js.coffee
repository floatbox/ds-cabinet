$ ->
  # Define forms IDs
  pre_new_registration_form = '#pre_new_registration_form'
  registraton_form = '#new_registration_form'
  confirmation = '#confirmation'
  not_found = '#not_found'
  verify_phone = '#verify_phone'
  deferred = '#deferred'
  complete = '#complete'
  sms_verification_code_sent = '#sms_verification_code_sent'

  # Hide all but the first form
  $(pre_new_registration_form).show()
  $(registraton_form).hide()
  $(confirmation).hide()
  $(not_found).hide()
  $(verify_phone).hide()
  $(deferred).hide()
  $(complete).hide()
  $(sms_verification_code_sent).hide()

  # Hide error messages blocks
  $('.error_messages').hide()

  window.LOCALE =
    base: 'Ошибка'
    phone: 'Телефон'
    ogrn: 'ОГРН'
    sms_verification_code: 'Код подтверждения'
    password: 'Пароль'
    password_confirmation: 'Подтверждение пароля'

  showPreloader = (form) ->
    form = $(form)
    form.addClass('submit-disabled')
    formLeft = form.position().left
    formTop = form.position().top
    formWidth = form.outerWidth()
    formHeight = form.outerHeight()
    preloader = $('img#preloader')
    width = preloader.outerWidth()
    height = preloader.outerHeight()
    preloader.css('left', "#{(formLeft + formWidth) / 2}px")
    preloader.css('top', "#{(formTop + formHeight) / 2}px")
    preloader.show()
    form.fadeTo('fast', 0.5)

  hidePreloader = (form) ->
    form = $(form)
    form.removeClass('submit-disabled')
    form.stop(true).fadeTo('fast', 1.0)
    $('img#preloader').hide()

  # Set masks on inputs
  $("#{pre_new_registration_form} input#registration_phone").mask('+7 (999) 999-99-99')
  $("#{pre_new_registration_form} input#registration_ogrn").mask('9999999999999?99')
  $("#{registraton_form} input#registration_phone").mask('+7 (999) 999-99-99')
  $("#{registraton_form} input#registration_ogrn").mask('9999999999999?99')
  $("#pre_registration_ogrn").mask('9999999999999?99')

  $('body').on 'keydown', "#{pre_new_registration_form} input#registration_phone, #{pre_new_registration_form} input#registration_ogrn", ->
    $('.promo').addClass('disabled')

  #
  # Helpers
  #

  # Replaces :registration_id placeholder with correct id.
  # @param element [jQuery] element that contains placeholder in any of its attributes
  # @param attribute [String] attribute with placeholder
  # @param id [String] correct id
  # @return [jQuery] fixed element
  replace_id = (element, attribute, id) ->
    value = element.attr(attribute)
    element.attr(attribute, value.replace('registration_id', id))

  # Finds or creates wrapper for error messages
  # @param attribute [jQuery] parent element of invalid input field
  # @return [jQuery] wrapper for error messages
  error_wrapper_for = (attribute) ->
    if attribute.find('span.errors').length is 0
      error = $('<span>', {class: 'errors'})
      attribute.append(error)
    attribute.find('span.errors')

  # Clears all error messages in registration form
  # @param form [String] selector of the form that should be cleared from error messages
  clear_error_messages = (form) ->
    $("#{form} .error_messages").empty().hide()

  # Shows errors messages in UI
  # @paran form [String] selector of validated form
  # @param errors [JSON] registation errors
  show_error_messages = (form, errors) ->
    form = $(form)
    error = form.find('.error_messages')
    message = ''
    for attribute, messages of errors
      element = $('<span>').text("#{LOCALE[attribute]}: #{messages.join(', ')}")
      error.append(element).append('<br/>')
    error.show()


  # Fills confirmation dialog
  # @param data [JSON] registration object as JSON
  fill_confirmation_dialog = (data) ->
    replace_id($(confirmation).find('a.confirm'), 'href', data.id)
    for key, value of data
      $(confirmation).find("span.#{key}").text(value)

  # Fills phone verification dialog
  # @param data [JSON] registration object as JSON
  fill_verify_phone_dialog = (data) ->
    replace_id($(verify_phone).find('form'), 'action', data.id)
    replace_id($(verify_phone).find('a.regenerate_sms_verification_code'), 'href', data.id)

  # Fills complete dialog
  # @param data [JSON] registration object as JSON
  fill_complete_dialog = (data) ->
    replace_id($(complete).find('form'), 'action', data.id)
    $(complete).find('span.phone').text(data.phone)

  # Removed promo blocks, their styles, shows next form with animation
  setup_registration_steps = (next_form) ->
    oldHeight = "#{$(next_form).outerHeight()}px"
    $(next_form).css(height:'0px')

    $('.main-wrapper').animate {top: '135px'}, 400, 'linear'
    $('.promo').addClass('disabled').animate {height:'0px'}, 400, 'linear', ->
      $(this).hide()
      $(next_form).show().css(opacity:'0')
      $(next_form).animate {height: oldHeight}, 200, 'linear', ->
        $(next_form).hide().css(opacity:'1').fadeIn()
        $('.main-wrapper').addClass('steps').removeClass('wrap-content')

    $(pre_new_registration_form).fadeOut()

  #
  # General callbacks
  #
  $('body').on 'click', 'a.new_registration', (event) ->
    event.preventDefault()
    $(registraton_form).show()

  #
  # Pre registration form callbacks
  #
  $('body').on 'ajax:before', pre_new_registration_form, (event, data) ->
    return false if $(pre_new_registration_form).hasClass('submit-disabled')
    showPreloader(pre_new_registration_form)

  $('body').on 'ajax:success', pre_new_registration_form, (event, data) ->
    hidePreloader(pre_new_registration_form)

    if data.workflow_state is 'deferred'
      setup_registration_steps(deferred)
    else
      fill_confirmation_dialog(data)
      fill_verify_phone_dialog(data)
      fill_complete_dialog(data)
      setup_registration_steps(confirmation)

  $('body').on 'ajax:error', pre_new_registration_form, (event, data) ->
    hidePreloader(pre_new_registration_form)
    errors = data.responseJSON
    if errors.company
      setup_registration_steps(not_found)
    else
      setup_registration_steps(registraton_form)
      show_error_messages(registraton_form, errors)

  #
  # Registration form callbacks
  #
  $('body').on 'ajax:before', registraton_form, (event, data) ->
    return false if $(registraton_form).hasClass('submit-disabled')
    showPreloader(registraton_form)
    clear_error_messages(registraton_form)

  $('body').on 'ajax:success', registraton_form, (event, data) ->
    hidePreloader(registraton_form)
    $(registraton_form).hide()

    if data.workflow_state is 'deferred'
      $(deferred).show()
    else
      fill_confirmation_dialog(data)
      fill_verify_phone_dialog(data)
      fill_complete_dialog(data)
      $(confirmation).show()

  $('body').on 'ajax:error', registraton_form, (event, data) ->
    hidePreloader(registraton_form)
    errors = data.responseJSON
    if errors.company
      $(registraton_form).hide()
      $(not_found).show()
    else
      show_error_messages(registraton_form, errors)


  #
  # Not found callbacks
  #

  $('body').on 'click', "#{not_found} a.back", (event) ->
    event.preventDefault()
    $(not_found).hide()
    $(registraton_form).show()


  #
  # Confirmation callbacks
  #

  $("#{confirmation} a.confirm").on 'ajax:before', (event, data) ->
    return false if $(confirmation).hasClass('submit-disabled')
    showPreloader(confirmation)

  $("#{confirmation} a.confirm").on 'ajax:success', (event, data) ->
    hidePreloader(confirmation)
    $(confirmation).hide()
    $(verify_phone).show()

  $("#{confirmation} a.confirm").on 'ajax:error', (event, data) ->
    hidePreloader(confirmation)
    show_error_messages(confirmation, data.responseJSON)

  $('body').on 'click', "#{confirmation} a.cancel", (event) ->
    event.preventDefault()
    $(confirmation).hide()
    $(registraton_form).show()

  #
  # Verify phone callbacks
  #

  $("#{verify_phone} form").on 'ajax:before', (event, data) ->
    return false if $(verify_phone).hasClass('submit-disabled')
    return unless event.target is this
    showPreloader(verify_phone)
    clear_error_messages(verify_phone)

  $("#{verify_phone} form").on 'ajax:success', (event, data) ->
    return unless event.target is this
    hidePreloader(verify_phone)
    $(verify_phone).hide()
    $(complete).show()

  $("#{verify_phone} form").on 'ajax:error', (event, data) ->
    return unless event.target is this
    hidePreloader(verify_phone)
    show_error_messages(verify_phone, data.responseJSON)

  $("#{verify_phone} a.regenerate_sms_verification_code").on 'ajax:success', (event, data) ->
    hidePreloader(verify_phone)
    $(verify_phone).hide()
    $(sms_verification_code_sent).show()

  #
  # SMS verification code sent callbacks
  #

  $('body').on 'click', "#{sms_verification_code_sent} a.ok", (event) ->
    event.preventDefault()
    $(sms_verification_code_sent).hide()
    $(verify_phone).show()

  #
  # Complete callbacks
  #

  $("#{complete} form").on 'ajax:before', (event, data) ->
    return false if $(complete).hasClass('submit-disabled')
    showPreloader(complete)
    clear_error_messages(complete)

  $("#{complete} form").on 'ajax:success', (event, data) ->
    hidePreloader(complete)
    $(complete).hide()
    location.reload()

  $("#{complete} form").on 'ajax:error', (event, data) ->
    hidePreloader(complete)
    show_error_messages(complete, data.responseJSON)

  $("#{complete} a.cancel").on 'click', (event) ->
    event.preventDefault()
    $(complete).hide()
    $(confirmation).show()