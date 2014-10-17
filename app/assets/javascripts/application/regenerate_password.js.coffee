$ ->
  class RegeneratePasswordForm
    TIMEOUT = 60 # seconds
    constructor: ->
      @default_success = @default_error = true
      @default_before = false
      @link_disabled = false
      @form = new RemoteForm('.js-regenerate_password_form', this)
      @countdown = new Countdown('.js-regenerate_password_link span.counter_text', TIMEOUT, @countdown_callback)
      @link = $('.js-regenerate_password_link')
      @link.click =>
        event.preventDefault()
        @form.form.submit() unless @link_disabled

    success: (event, data) =>
      Dialog.info_text(["Пароль успешно отправлен на телефон, проверьте смс"])
      @countdown.start()

    error: (event, data, textStatus) =>
      Dialog.show_errors_json(data.responseJSON)
      @countdown.start()

    before: (event, data) =>
      @link_disabled = true 
      Preloader.show(@link)

    countdown_callback: () =>
      @link_disabled = false

  new RegeneratePasswordForm()
