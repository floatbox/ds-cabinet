$ ->
  # Define forms IDs
  registraton_form = '#new_registration_form'
  confirmation = '#confirmation'
  not_found = '#not_found'
  complete = '#complete'
  sms_verification_code_sent = '#sms_verification_code_sent'

  # Hide all but the first form
  $(registraton_form).hide()
  $(confirmation).hide()
  $(not_found).hide()
  $(complete).hide()
  $(sms_verification_code_sent).hide()

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
    $("#{form} span.errors").text('')

  # Shows errors messages in UI
  # @paran form [String] selector of validated form
  # @param errors [JSON] registation errors
  show_error_messages = (form, errors) ->
    form = $(form)
    for attribute, messages of errors
      wrapper = form.find(".registration_#{attribute}").parent()
      error = error_wrapper_for(wrapper)
      error.text(messages.join(', '))

  # Fills confirmation dialog
  # @param data [JSON] registration object as JSON
  fill_confirmation_dialog = (data) ->
    replace_id($(confirmation).find('a.confirm'), 'href', data.id)
    for key, value of data
      $(confirmation).find("span.#{key}").text(value)

  # Fills complete dialog
  # @param data [JSON] registration object as JSON
  fill_complete_dialog = (data) ->
    replace_id($(complete).find('form'), 'action', data.id)
    replace_id($(complete).find('a.regenerate_sms_verification_code'), 'href', data.id)
    $(complete).find('span.login').text(data.phone)

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
    clear_error_messages(registraton_form)

  $('body').on 'ajax:success', registraton_form, (event, data) ->
    fill_confirmation_dialog(data)
    fill_complete_dialog(data)
    $(registraton_form).hide()
    $(confirmation).show()

  $('body').on 'ajax:error', registraton_form, (event, data) ->
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

  $("#{confirmation} a.confirm").on 'ajax:success', (event, data) ->
    $(confirmation).hide()
    $(complete).show()

  $('body').on 'click', "#{confirmation} a.cancel", (event) ->
    event.preventDefault()
    $(confirmation).hide()
    $(registraton_form).show()


  #
  # Complete callbacks
  #

  $("#{complete} form").on 'ajax:before', (event, data) ->
    return unless event.target is this
    clear_error_messages(complete)

  $("#{complete} form").on 'ajax:success', (event, data) ->
    return unless event.target is this
    alert('Вы успешно зарегистрировались!')
    $(complete).hide()

  $("#{complete}").on 'ajax:error', (event, data) ->
    show_error_messages(complete, data.responseJSON)

  $("#{complete} a.regenerate_sms_verification_code").on 'ajax:success', (event, data) ->
    $(complete).hide()
    $(sms_verification_code_sent).show()

  $("#{complete} a.cancel").on 'click', (event) ->
    event.preventDefault()
    $(complete).hide()
    $(confirmation).show()

  #
  # SMS verification code sent callbacks
  #

  $('body').on 'click', "#{sms_verification_code_sent} a.ok", (event) ->
    event.preventDefault()
    $(sms_verification_code_sent).hide()
    $(complete).show()