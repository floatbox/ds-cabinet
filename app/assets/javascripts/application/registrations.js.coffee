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
      dialog_selector = "#confirm_dialog_id_" + payment.offering_price_id
      $(dialog_selector + ' form.js-process_payment_form').attr('action', payment.link)
      $(dialog_selector + ' span.js-process_payment_amount').text(payment.amount)
      $(dialog_selector).modal("show")
  
  regStep1 = new PageFragment('.registration_input_fragment',   '/virtual/step1')
  regStep2 = new PageFragment('.registration_confirm_fragment', '/virtual/step2')
  regStep3 = new PageFragment('.tariff_select_fragment',        '/virtual/step3')
  regStep1.set_next_prev(regStep2, null)
  regStep2.set_next_prev(regStep3, regStep1)
  regStep3.set_next_prev(null,     regStep2)
