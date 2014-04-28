$ ->
  # Define forms IDs
  registraton_form = '#new_registration_form'
  confirmation = '#confirmation'
  not_found = '#not_found'
  verify_phone = '#verify_phone'
  complete = '#complete'
  sms_verification_code_sent = '#sms_verification_code_sent'

  # Hide all but the first form
  $(registraton_form).show()
  $(confirmation).hide()
  $(not_found).hide()
  $(verify_phone).hide()
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

  hidePreloader = (form) ->
    $('img#preloader').hide()

  # Set masks on inputs
  $("#{registraton_form} input#registration_phone").mask('+7 (999) 999-99-99')
  $("#{registraton_form} input#registration_ogrn").mask('9999999999999?99')

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

  #
  # General callbacks
  #
  $('body').on 'click', 'a.new_registration', (event) ->
    event.preventDefault()
    $(registraton_form).show()

  #
  # Registration form callbacks
  #
  $('body').on 'ajax:before', registraton_form, (event, data) ->
    $(this).fadeTo('fast', 0.5)
    showPreloader(registraton_form)
    clear_error_messages(registraton_form)

  $('body').on 'ajax:success', registraton_form, (event, data) ->
    $(this).stop(true).fadeTo('fast', 1.0)
    hidePreloader(registraton_form)
    fill_confirmation_dialog(data)
    fill_verify_phone_dialog(data)
    fill_complete_dialog(data)
    $(registraton_form).hide()
    $(confirmation).show()

  $('body').on 'ajax:error', registraton_form, (event, data) ->
    $(this).stop(true).fadeTo('fast', 1.0)
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
    $(confirmation).fadeTo('fast', 0.5)

  $("#{confirmation} a.confirm").on 'ajax:success', (event, data) ->
    $(confirmation).stop(true).fadeTo('fast', 1.0)
    $(confirmation).hide()
    $(verify_phone).show()

  $('body').on 'click', "#{confirmation} a.cancel", (event) ->
    event.preventDefault()
    $(confirmation).hide()
    $(registraton_form).show()

  #
  # Verify phone callbacks
  #

  $("#{verify_phone} form").on 'ajax:before', (event, data) ->
    return unless event.target is this
    $(verify_phone).fadeTo('fast', 0.5)
    clear_error_messages(verify_phone)

  $("#{verify_phone} form").on 'ajax:success', (event, data) ->
    return unless event.target is this
    $(verify_phone).stop(true).fadeTo('fast', 1.0)
    $(verify_phone).hide()
    $(complete).show()

  $("#{verify_phone} form").on 'ajax:error', (event, data) ->
    return unless event.target is this
    $(verify_phone).stop(true).fadeTo('fast', 1.0)
    show_error_messages(verify_phone, data.responseJSON)

  $("#{verify_phone} a.regenerate_sms_verification_code").on 'ajax:success', (event, data) ->
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
    $(this).fadeTo('fast', 0.5)
    showPreloader(complete)
    clear_error_messages(complete)

  $("#{complete} form").on 'ajax:success', (event, data) ->
    $(this).stop(true).fadeTo('fast', 1.0)
    hidePreloader(complete)
    alert('Вы успешно зарегистрировались!')
    $(complete).hide()

  $("#{complete} form").on 'ajax:error', (event, data) ->
    $(this).stop(true).fadeTo('fast', 1.0)
    hidePreloader(complete)
    show_error_messages(complete, data.responseJSON)

  $("#{complete} a.cancel").on 'click', (event) ->
    event.preventDefault()
    $(complete).hide()
    $(confirmation).show()