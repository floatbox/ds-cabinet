$ ->
  # Define forms IDs
  registraton_form = '#new_registration_form'
  confirmation = '#confirmation'
  not_found = '#not_found'
  complete = '#complete'
  sms_verification_code_sent = '#sms_verification_code_sent'

  # Hide all but the first form
  $(confirmation).hide()
  $(not_found).hide()
  $(complete).hide()
  $(sms_verification_code_sent).hide()

  #
  # Helpers
  #

  # Finds or creates wrapper for error messages
  # @param attribute [jQuery] parent element of invalid input field
  # @return [jQuery] wrapper for error messages
  error_wrapper_for = (attribute) ->
    if attribute.find('span.errors').length is 0
      error = $('<span>', {class: 'errors'})
      attribute.append(error)
    attribute.find('span.errors')

  # Clears all error messages in registration form
  clear_error_messages = ->
    $("#{registraton_form} span.errors").text('')

  # Show errors in registration form
  # @param errors [JSON] registation errors
  show_error_messages = (errors) ->
    for attribute, messages of errors
      wrapper = $("#{registraton_form} .registration_#{attribute}").parent()
      error = error_wrapper_for(wrapper)
      error.text(messages.join(', '))

  # Fills confirmation dialog
  # @param data [JSON] registration object as JSON
  fill_confirmation_dialog = (data) ->
    for key, value of data
      $(confirmation).find("span.#{key}").text(value)

  # Fills complete dialog
  # @param data [JSON] registration object as JSON
  fill_complete_dialog = (data) ->
    # Set correct id to action
    form = $(complete).find('form')
    action = form.attr('action')
    form.attr('action', action.replace('registration_id', data.id))

    # Set correct id to sms verification code link
    link = $(complete).find('a.regenerate_sms_verification_code')
    href = link.attr('href')
    link.attr('href', href.replace('registration_id', data.id))

    # Set login
    $(complete).find('span.login').text(data.phone)


  #
  # Registration form callbacks
  #
  $('body').on 'ajax:before', registraton_form, (event, data) ->
    clear_error_messages()

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
      show_error_messages(errors)


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

  $('body').on 'click', "#{confirmation} a.cancel", (event) ->
    event.preventDefault()
    $(confirmation).hide()
    $(registraton_form).show()

  $('body').on 'click', "#{confirmation} a.ok", (event) ->
    event.preventDefault()
    $(confirmation).hide()
    $(complete).show()


  #
  # Complete callbacks
  #

  $("#{complete} form").on 'ajax:success', (event, data) ->
    return unless event.target is this
    alert('Вы успешно зарегистрировались!')
    $(complete).hide()

  $("#{complete}").on 'ajax:error', (event, data) ->
    alert('Something goes wrong!')

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