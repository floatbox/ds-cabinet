$ ->
  # Define forms IDs
  pre_new_registration_form = '#pre_new_registration_form'
  registraton_form = '#new_registration_form'
  confirmation = '#confirmation'
  not_found = '#not_found'
  select_payment = '#select_payment'
  process_payment = '#process_payment'
  deferred = '#deferred'
  password_sent = '#password_sent'

  # Hide all but the first form
  $(pre_new_registration_form).show()
  $(registraton_form).hide()
  $(confirmation).hide()
  $(not_found).hide()
  $(select_payment).hide()
  $(process_payment).hide()
  $(deferred).hide()
  $(password_sent).hide()

  # Hide error messages blocks
  $('.error_messages').hide()

  window.LOCALE =
    base: 'Ошибка'
    phone: 'Телефон'
    ogrn: 'ОГРН'
    password: 'Пароль'
    offering: 'Тарифный план'

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
    replace_id($(confirmation).find('form'), 'action', data.id)
    replace_id($('a.regenerate_password'), 'href', data.id)
    for key, value of data
      $(confirmation).find("span.#{key}").text(value)

  # Fills payment confirmation dialog
  # @param data [JSON] registration object as JSON
  fill_select_payment_dialog = (data) ->
    replace_id($(select_payment).find('a.select_payment_link'), 'href', data.id)

  # Fills payment confirmation dialog
  # @param data [JSON] hash object as JSON:
  # { 
  #   :process_payment_link => 'http://paymentgate/uuid'
  #   :process_payment_desc => 'Описание и цена выбранного тарифного плана'
  # }
  fill_process_payment_dialog = (data) ->
    replace_id($(process_payment).find('form'), 'action', data.process_payment_link)
    $("#{process_payment} span.process_payment_desc").text(data.process_payment_desc)

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
    $('.promo').addClass('disabled')
    return false if $(pre_new_registration_form).hasClass('submit-disabled')
    showPreloader(pre_new_registration_form)

  $('body').on 'ajax:success', pre_new_registration_form, (event, data) ->
    hidePreloader(pre_new_registration_form)

    if data.workflow_state is 'deferred'
      setup_registration_steps(deferred)
    else
      fill_confirmation_dialog(data)
      fill_select_payment_dialog(data)
      setup_registration_steps(password_sent)
      ga('send', 'pageview', '/virtual/step2')

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
      fill_select_payment_dialog(data)
      $(password_sent).show()
      ga('send', 'pageview', '/virtual/step2')

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
  $("#{confirmation} form").on 'ajax:before', (event, data) ->
    return false if $(confirmation).hasClass('submit-disabled')
    return unless event.target is this
    showPreloader(confirmation)
    clear_error_messages(confirmation)

  $("#{confirmation} form").on 'ajax:success', (event, data) ->
    hidePreloader(confirmation)
    $(confirmation).hide()
    $(select_payment).show()
    ga('send', 'pageview', '/virtual/step3')

  $("#{confirmation} form").on 'ajax:error', (event, data) ->
    hidePreloader(confirmation)
    show_error_messages(confirmation, data.responseJSON)

  $("#{confirmation} a.regenerate_password").on 'ajax:before', (event, data) ->
    showPreloader(confirmation)
    clear_error_messages(confirmation)

  $("#{confirmation} a.regenerate_password").on 'ajax:success', (event, data) ->
    hidePreloader(confirmation)
    $(confirmation).hide()
    clear_error_messages(confirmation)
    $(password_sent).show()
    ga('send', 'pageview', '/virtual/step4')

  $('body').on 'click', "#{confirmation} a.cancel", (event) ->
    event.preventDefault()
    clear_error_messages(confirmation)
    $(confirmation).hide()
    $(registraton_form).show()


  #
  # Password sent callbacks
  #
  $('body').on 'click', "#{password_sent} a.ok", (event) ->
    event.preventDefault()
    $(password_sent).hide()
    $(confirmation).show()


  #
  # Select payment callbacks
  #
  $("#{select_payment} a.select_payment_link").on 'ajax:before', (event, data) ->
    showPreloader(select_payment)
    clear_error_messages(select_payment)

  $("#{select_payment} a.select_payment_link").on 'ajax:success', (event, data) ->
    hidePreloader(select_payment)
    fill_process_payment_dialog(data)
    $(select_payment).hide()
    $(process_payment).show()

  $("#{select_payment} a.select_payment_link").on 'ajax:error', (event, data) ->
    return unless event.target is this
    hidePreloader(select_payment)
    show_error_messages(select_payment, data.responseJSON)


  #
  # Process payment callbacks
  #
  $("#{process_payment} form button").on 'click', (event) ->
    showPreloader(process_payment)
    clear_error_messages(process_payment)
 
  $('body').on 'click', "#{process_payment} a.cancel", (event) ->
    event.preventDefault()
    $(process_payment).hide()
    $(select_payment).show()
