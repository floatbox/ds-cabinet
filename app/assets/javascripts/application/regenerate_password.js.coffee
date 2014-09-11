$ ->
  class RegeneratePasswordForm

    constructor: ->
      @default_success = @default_error = true
      @default_before = false
      @link_disabled = false
      @form = new RemoteForm('.js-regenerate_password_form', this)
      @link = $('.js-regenerate_password_link')
      @link.click =>
        event.preventDefault()
        @form.form.submit() unless @link_disabled

    success: (event, data) =>
      @link_disabled = false
      Dialog.info_text(["Пароль успешно отправлен на телефон, проверьте смс"])

    error: (event, data, textStatus) =>
      Dialog.show_errors_json(data.responseJSON)
      @link_disabled = false 

    before: (event, data) =>
      @link_disabled = true 
      Preloader.show(@link)

  new RegeneratePasswordForm()
