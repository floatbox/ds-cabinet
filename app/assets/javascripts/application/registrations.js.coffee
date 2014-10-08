$ ->
  class PageFragment extends Module
    @include Chainable

    @set_registration_data: (registration) ->
      # set registration attributes for confiration form
      for key, value of registration
        span_class_name = "js-registration_"+key
        selector = "span.#{span_class_name}"
        $(selector).text(value)

      # set registration id for confiration form
      arr = ['form.js-confirmation_form', 'form.js-regenerate_password_form']
      for selector in arr
        element = $(selector)
        value = element.attr('action')
        element.attr('action', value.replace('registration_id', registration.id))

    constructor: (@selector, @ga_url) ->
      @default_success = @default_error = @default_before = true
      @form = new RemoteForm($(@selector).find(".simple_form"), this)
      back_link = $(@selector).find(".js-back")
      back_link.click( => 
        @switch_prev()
        event.preventDefault()
      )

    hide: -> $(@selector).hide()
    show: -> $(@selector).show()

    error: (event, data, textStatus) => 
      Dialog.show_errors_json(data.responseJSON)

    success: (event, data) =>
      ga('send', 'pageview', @ga_url) if @ga_url
      if data
        PageFragment.set_registration_data(data.registration) if data.registration
        @set_payment_data(data.payment) if data.payment
      @switch_next()

    set_payment_data: (payment) =>
      $(@selector).find('span.js-process_payment_desc').text(payment.process_payment_desc)
      $(@selector).find('form.js-process_payment_form').attr('action', payment.process_payment_link)
      $('#js-modal_success_dialog').modal("show")
  
  regStep1 = new PageFragment('.registration_input_fragment',   '/virtual/step1')
  regStep2 = new PageFragment('.registration_confirm_fragment', '/virtual/step2')
  regStep3 = new PageFragment('.tariff_select_fragment',        '/virtual/step3')
  regStep1.set_next_prev(regStep2, null)
  regStep2.set_next_prev(regStep3, regStep1)
  regStep3.set_next_prev(null,     regStep2)


  # Define messages IDs
  ogrn_not_found_msg  = 'ogrn_not_found_msg' # ОГРНИП в базе ФНС не найден
  ogrn_in_use_msg     = 'ogrn_in_use_msg'    # ОГРНИП уже использовался при регистрации
  phone_in_use_msg    = 'phone_in_use_msg'   # Телефон уже использовался для регистрации
  password_sent_msg   = 'password_sent_msg'  # Пароль отослан в смс

  # Define forms IDs
  registraton_form = '#new_registration'
  confirmation = '#confirmation'
  not_found = '#not_found'
  select_payment = '#select_payment'
  process_payment = '#process_payment'
  deferred = '#deferred'
  password_sent = '#password_sent'


  $('body').on 'keydown', "input.phone, input.ogrn", ->
    $('.promo').addClass('disabled')
###
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
      element = $('<span>').text("#{LOCALE[attribute]} #{messages.join(', ')}")
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
  #   process_payment_link: 'http://payment-delo.sredda.ru:8081/Payment/Credentials?PaymentID=688e29a5-41b6-4452-8d60-c3d498d9dac5'
  #   process_payment_desc: '3 месяца'
  # }
  fill_process_payment_dialog = (data) ->
    $(process_payment).find('form').attr('action', data.process_payment_link)
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
    return false if $(registraton_form).hasClass('submit-disabled')
    showPreloader(registraton_form)
    clear_error_messages(registraton_form)

  $('body').on 'ajax:complete', registraton_form, (event, data) ->
    disableForm(registraton_form)

  $('body').on 'ajax:success', registraton_form, (event, data) ->
    hidePreloader(registraton_form)
    $(registraton_form).hide()

    if data.workflow_state is 'deferred'
      $(deferred).show()
      enableForm(registraton_form)
    else
      fill_confirmation_dialog(data)
      fill_select_payment_dialog(data)
   $(password_sent).show()
      ga('send', 'pageview', '/virtual/step2')

  $('body').on 'ajax:error', registraton_form, (event, data) ->
    hidePreloader(registraton_form)
    errors = data.responseJSON
    enableForm(registraton_form)
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
    enableForm(registraton_form)


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
###
